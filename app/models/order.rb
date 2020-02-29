class Order < ApplicationRecord
  acts_as_paranoid
  belongs_to :billing_address, class_name: 'CustomerAddress', dependent: :destroy
  belongs_to :shipping_address, class_name: 'CustomerAddress', dependent: :destroy
  has_many :line_items, class_name: 'OrderLineItem', inverse_of: :order, dependent: :destroy
  # has_many :order_transactions, dependent: :destroy
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :line_items, allow_destroy: true

  store :note_attributes, coder: JSON

  validates :shopify_order_id, presence: true, uniqueness: true
  validates :shopify_customer_id, presence: true
  validates :currency, presence: true
  validates :email, presence: true
  validates :name, presence: true
  validates :number, presence: true
  validates :order_number, presence: true
  validates :subtotal_price, presence: true#, numericality: { greater_than: 0 }
  validates :total_line_items_price, presence: true#, numericality: { greater_than: 0 }
  validates :total_price, presence: true#, numericality: { greater_than: 0 }

  scope :processing, -> { self }
  scope :api_error, -> { self }
  scope :shipped, -> { self }
  scope :cancelled, -> { self }
  scope :refunded, -> {where(financial_status:'refunded')}
  scope :paid, -> {where(financial_status:'paid')}
  scope :authorized, -> {where(financial_status:'authorized')}
  scope :failed, -> { api_error }

  def self.build_attributes_from_shopify_order(order_data, update_set = false)
    res = {
      shopify_order_id:     order_data[:id],
      shopify_customer_id:  order_data[:customer][:id],
      cancel_reason:        order_data[:cancel_reason],
      cancelled_at:         order_data[:cancelled_at],
      closed_at:            order_data[:closed_at],
      currency:             order_data[:currency],
      email:                order_data[:email],
      financial_status:     order_data[:financial_status],
      fulfillment_status:   order_data[:fulfillment_status],
      name:                 order_data[:name],
      note:                 order_data[:note],
      number:               order_data[:number],
      order_number:         order_data[:order_number],
      phone:                order_data[:phone],
      processed_at:         order_data[:processed_at],
      refunds:              order_data[:refunds].to_json,
      subtotal_price:       order_data[:subtotal_price],
      taxes_included:       order_data[:taxes_included],
      token:                order_data[:token],
      total_discounts:      order_data[:total_discounts],
      total_line_items_price:order_data[:total_line_items_price],
      total_price:          order_data[:total_price],
      total_tax:            order_data[:total_tax],
      total_weight:         order_data[:total_weight],
      order_status_url:     order_data[:order_status_url],
      note_attributes:      order_data[:note_attributes].map{ |na| [na[:name], na[:value]] }.to_h,
      tags:                 order_data[:tags],
    }
    if !update_set
      res = res.merge({
        created_at:           order_data[:created_at],
        updated_at:           order_data[:updated_at],
      })
    end

    res
  end

  def self.create_from_shopify_order!(order_data, skip_processing = false)
    ActiveJob::Base.logger.debug "create_from_shopify_order! started\n"
    # _user = User.find_by_shopify_customer_id!(order_data[:customer][:id])
    _billing_address = CustomerAddress.build_attributes_from_shopify_address(order_data[:billing_address], CustomerAddress.address_types[:billing])
    _shipping_address = CustomerAddress.build_attributes_from_shopify_address(order_data[:shipping_address], CustomerAddress.address_types[:shipping])

    # _tax_lines = []
    # order_data[:tax_lines].each do |tl|
    #   _tax_lines << {
    #     title:  tl[:title],
    #     price:  tl[:price],
    #     rate:   tl[:rate]
    #   }
    # end

    _line_items = []
    order_data[:line_items].each do |li|
      _line_items << OrderLineItem.build_attributes_from_shopify_line_item(li)
    end

    self.transaction do
      # self.lock('SHARE')
      ActiveRecord::Base.connection.execute('LOCK TABLE orders, order_line_items IN EXCLUSIVE MODE') if \
      !(Rails.env.test? || Rails.env.development?) || Rails.configuration.try(:enable_long_tests)
      ActiveJob::Base.logger.debug "Order Creation: locked!\n"
      attrs = self.build_attributes_from_shopify_order(order_data).merge({
          # user:                            _user,
          line_items_attributes:           _line_items,
          # tax_lines_attributes:            _tax_lines,
        })
      attrs[:shipping_address_attributes] = _shipping_address if _shipping_address.present?
      attrs[:billing_address_attributes] = _billing_address if _billing_address.present?
      ActiveJob::Base.logger.debug "before self.create!(attrs)\n"
      new_order = self.create!(attrs)
      ActiveJob::Base.logger.info "order.create_from_shopify_order! inserted #{new_order.line_items.count} line_items\n"
      if new_order
        # if new_order.recharge_order.blank?
        #   EventLog.create_from_method!("Order##{new_order.id}", "create_from_shopify_order!", "recharge_order is missing", nil)
        # end

        # new_order.recharge_order.try(:validate_note_attributes)
        # begin
        #   # process overrides for note_attributes
        #   new_order.reserve_product_variants!
        # rescue BaseError => e #in case of error, continue with creation, but skip reservation
        #   ActiveJob::Base.logger.error "order.create_from_shopify_order! error during reserve_product_variants!: #{e}\n"
        #   EventLog.create_from_method!("Order", "create_from_shopify_order!", "error during reserve_product_variants", e)
        # end
      end
      ActiveJob::Base.logger.debug "Order Creation finished!\n"
      new_order
    end
  end

  def self.update_from_shopify_order!(order_data, financial_transactions = false, skip_processing = false)
    ActiveRecord::Base.transaction do
      ActiveJob::Base.logger.debug "Ok, transaction started!\n"
      ActiveRecord::Base.connection.execute("LOCK TABLE orders, order_line_items IN EXCLUSIVE MODE") if \
      !(Rails.env.test? || Rails.env.development?) || Rails.configuration.try(:enable_long_tests)
      ActiveJob::Base.logger.debug "Order Update: orders, order_line_items locked!\n"

      # locking order row
      current_order = Order.where(shopify_order_id: order_data[:id]).lock(true).first

      if order_data[:financial_status].in?(["refunded", "voided"]) && !(current_order.financial_status.in?(["refunded", "voided"]))
        financial_transactions = "refund" if financial_transactions.blank?
      end

      # if financial_transactions
      #   acquire_locks_for = "order_transactions, user_transactions"
      #   ActiveRecord::Base.connection.execute("LOCK TABLE #{acquire_locks_for} IN EXCLUSIVE MODE") if \
      #     !Rails.env.test? || Rails.configuration.try(:enable_long_tests)
      #   ActiveJob::Base.logger.debug "Order Update: order_transactions, user_transactions locked!\n"
      # end

      raise ShopifyOrderMissingError.new(order_data[:id], "Order::update_from_shopify_order!") if current_order.blank?

      _billing_address = CustomerAddress.build_attributes_from_shopify_address(order_data[:billing_address], CustomerAddress.address_types[:billing])
      _shipping_address = CustomerAddress.build_attributes_from_shopify_address(order_data[:shipping_address], CustomerAddress.address_types[:shipping])

      _line_items = []
      order_data[:line_items].each do |li|
        _line_items << OrderLineItem.build_attributes_from_shopify_line_item(li)
      end

      current_li_ids = current_order.line_items.map{ |li| li.id }
      _line_items.each_with_index do |updated_li, updated_li_index|
        current_li = current_order.line_items.where(shopify_line_item_id: updated_li[:shopify_line_item_id]).first
        if current_li.present?
          current_li_ids.delete current_li.id
          _line_items[updated_li_index][:id] = current_li.id
        end
      end
      # remove items that are not included in the updated list
      current_li_ids.each do |li_id|
        _line_items << {id: li_id, _destroy: '1'}
      end

      # _tax_lines = []
      # order_data[:tax_lines].each do |tl|
      #   _tax_lines << {
      #     title:  tl[:title],
      #     price:  tl[:price],
      #     rate:   tl[:rate]
      #   }
      # end
      # current_tl_titles = current_order.tax_lines.map{ |tl| tl.title }
      # # items to add through order attributes
      # new_tax_lines = []
      # _tax_lines.each do |updated_tl|
      #   # if current_tl_titles.include? updated_tl.title
      #   # ActiveJob::Base.logger.debug "tax_lines.where!\n"
      #   current_tl = current_order.tax_lines.where(title: updated_tl[:title]).first
      #   if current_tl.present?
      #     # ActiveJob::Base.logger.debug "current_tl.update!\n"
      #     current_tl.update_attributes! updated_tl
      #     current_tl_titles.delete updated_tl[:title]
      #   else
      #     new_tax_lines << updated_tl
      #   end
      # end
      # remove items that are not included in the updated list
      # current_tl_titles.each do |tl_title|
      #   new_tax_lines << {id: current_order.tax_lines.where(title: tl_title).first.try(:id), _destroy: '1'}
      # end

      ActiveJob::Base.logger.debug "current_order.update_attributes!\n"

      old_financial_status = current_order.financial_status

      attrs = self.build_attributes_from_shopify_order(order_data).merge({
        # user:                 _user,
        line_items_attributes:           _line_items,
        # tax_lines_attributes:            new_tax_lines,
      })
      attrs[:shipping_address_attributes] = _shipping_address if _shipping_address.present?
      attrs[:billing_address_attributes] = _billing_address if _billing_address.present?
      res = current_order.update!(attrs)
      ActiveJob::Base.logger.info "order.update_from_shopify_order! After update has #{current_order.line_items.count} line_items\n"
      if res
        begin
          # process payment only if recharge_order already received and by its subscription we can for sure know overrides for note_attributes
          # if current_order.recharge_order.present?
          #   current_order.recharge_order.validate_note_attributes unless skip_processing
          #   if "payment" == financial_transactions && !OrderTransaction.where(order: current_order, type: OrderTransaction.types[:payment]).exists?
          #     current_order.create_payment_transactions!
          #   end
          # end
        rescue BaseError => e #in case of error, continue updates, but skip transactions
          ActiveJob::Base.logger.error "order.update_from_shopify_order! error during create_payment_transactions!: #{e}\n"
          EventLog.create_from_method!("Order", "update_from_shopify_order!", "error during create_payment_transactions", e)
        end
        #check if we need to process refunds then
        if "refund" == financial_transactions
          # order_transaction = OrderTransaction.where(order: current_order, type: "payment").first
          # if order_transaction.present?
          #   begin
          #     order_transaction.issue_refund! "shopify_refund"
          #   rescue BaseError => e #in case of error, continue updates, but skip transactions
          #     ActiveJob::Base.logger.error "order.update_from_shopify_order! error during issue_refund!: #{e}\n"
          #     EventLog.create_from_method!("Order", "update_from_shopify_order!", "error during issue_refund", e)
          #   end
          # end
        end
      end
      ActiveJob::Base.logger.debug "order.update_from_shopify_order! ended\n"
      res
    end #ActiveRecord::Base.transaction do
  end

  def self.dashboard_status
    {
      processing: Order.processing.count,
      failed:     Order.api_error.count,
      shipped:    Order.shipped.count,
      cancelled:  Order.cancelled.count
    }
  end

  def mark_shopify_order_as_fulfilled(tracking_company, tracking_number)
    Shop.activate_installed_shop_session
    shopify_order = ShopifyAPI::Order.find(shopify_order_id)
    f_hash = {
      order_id: shopify_order_id,
      line_items: shopify_order.line_items.map{ |li| {id: li.id} },
      notify_customer: true,
      location_id: ShopifyAPI::Location.first.id,
      shipment_status: 'in_transit',
      tracking_company: tracking_company,
      tracking_numbers: [ tracking_number ]
    }
    fulfillment = ShopifyAPI::Fulfillment.create(f_hash)
    errors = fulfillment.errors.present? ? fulfillment.errors.to_a.map(&:to_s).join(",") : ""
    is_already_fulfillled = errors.include?("is already fulfilled")
    if (fulfillment.errors.present? || "success" != fulfillment.status) && !is_already_fulfillled
      raise "Order::mark_shopify_order_as_fulfilled: Fulfillment not created:" +
        fulfillment.errors.to_a.map(&:to_s).join(",")
    end
    update!(fulfillment_status: 'fulfilled')
  rescue StandardError => e
    EventLog.create_from_method!('Order', 'mark_shopify_order_as_fulfilled', 
      "Cannot fulfill order %s" % [shopify_order_id], e)
    if Rails.env.development?
      raise e
    end
    return false
  end

  def products
    products = []
    packages = []
    line_items.each do |li|
      package = PackageHelper::Exec.package_name(li.title)
      ignore_li = li.title.include?("Sales Tax") || li.title.include?("Local sales tax") || li.title.include?("Juvinesse Skin System Starter Kit") || li.title.include?("Juvinesse Skin System Device")
      unless ignore_li
        ignore_li = li.product.present? && (li.product.tags.include?("sales_tax") || li.product.tags.include?("skin_system_device"))
      end
      next if ignore_li
      if package.present?
        packages << "#{package} Package(#{li.quantity})"
      else# if li.product.present? && !li.product.tags.include?("sales_tax") && !li.product.tags.include?("skin_system_device")
        products << "#{li.title}(#{li.quantity})"
      end
    end
    products + packages
  end

  def product_names
    products.present? ? products.join(", ") : "Missing"
  end

  def package_name
    line_items.each do |li|
      package = PackageHelper::Exec.package_name(li.title)
      return package if package.present?
    end
    "Other"
  end

  def line_item_for_package
    line_items.each do |li|
      package = PackageHelper::Exec.package_name(li.title)
      return li if package.present?
    end
    return nil
  end

  def self.set_shipment(order_id, line_item_id, date, carrier, tracking_id)
    order = self.find_by_shopify_order_id!(order_id)
    shipments = order.shipments || {}
    shipments[line_item_id] = {
      date: date,
      carrier: carrier,
      tracking_id: tracking_id
    }
    order.update!(
      shipments: shipments,
    )
    order.mark_shopify_order_as_fulfilled(carrier, tracking_id)
  end

  def self.set_cancellation(order_id, line_item_id, date, error_id, error_code, error_identifier)
    order = self.find_by_shopify_order_id!(order_id)
    cancellations = order.cancellations || {}
    cancellations[line_item_id] = {
      date: date,
      error_id: error_id,
      error_code: error_code,
      error_identifier: error_identifier
    }
    order.update!(
      cancellations: cancellations,
    )
  end

  def possible_errors
    errors = []
    errors << "No user commissions added, check commission percentages" if OrderTransaction.where(order: self).includes(:user_transactions).where(user_transactions: { reason_object_type: nil}).exists? unless seller_problems.present?
    errors
  end
end
