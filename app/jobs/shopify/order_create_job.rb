class Shopify::OrderCreateJob < ApplicationJob
  queue_as :critical
 
  def perform(args)
    shop_domain = args[:shop_domain]
    order_data = args[:order]

    # Allow some delay before shopify customer appears in our database
    # retries = (max_delay / 0.5).round
    # customer_found = false
    # all_products_found = false
    # all_variants_found = false
    # missing_product_id = nil
    # missing_variant_id = nil
    # ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
    #   ActiveRecord::Base.connection.uncached do
    #     while retries > 0
    #       customer_found ||= User.find_by_shopify_customer_id(order_data[:customer][:id]).present?
    #       unless all_products_found
    #         missing_product_id = nil
    #         all_products_found_status = true
    #         order_data[:line_items].each do |li|
    #           all_products_found_status &&= li[:product_exists].blank? || Product.find_by_shopify_product_id(li[:product_id])
    #           missing_product_id = li[:product_id] unless all_products_found_status
    #           break unless all_products_found_status
    #         end
    #         all_products_found ||= all_products_found_status
    #       end
    #       unless all_variants_found
    #         missing_variant_id = nil
    #         all_variants_found_status = true
    #         order_data[:line_items].each do |li|
    #           all_variants_found_status &&= ProductVariant.find_by_shopify_variant_id(li[:variant_id])
    #           missing_variant_id = li[:variant_id] unless all_variants_found_status
    #           break unless all_variants_found_status
    #         end
    #         all_variants_found ||= all_variants_found_status
    #       end
    #       break if customer_found && all_products_found && all_variants_found
    #       sleep 0.5
    #       retries -= 1
    #     end
    #   end
    # end

    # ActiveJob::Base.logger.error "OrderCreateJob##{order_data[:id]}: No Shopify Customer found!!!" unless customer_found
    # ActiveJob::Base.logger.error "OrderCreateJob##{order_data[:id]}: No Shopify Product found!!!" if missing_product_id.present?
    # ActiveJob::Base.logger.error "OrderCreateJob##{order_data[:id]}: No Shopify Variant found!!!" if missing_variant_id.present?
    # raise ShopifyCustomerMissingError.new(order_data[:customer][:id], "OrderCreateJob") unless customer_found
    # raise ShopifyProductMissingError.new(missing_product_id, "OrderCreateJob") if missing_product_id.present?
    # raise ShopifyVariantMissingError.new(missing_variant_id, "OrderCreateJob") if missing_variant_id.present?

    # it was deleted somehow
    if Order.only_deleted.where(shopify_order_id: order_data[:id]).exists?
      EventLog.create_event!({
        type: "warning",
        internal_name: "Shopify::OrderCreateJob",
        group: "methods",
        controller: 'Shopify::OrderCreateJob',
        action: 'perform',
        params: { order: args },
        exception_message: "Order was deleted, ID: #{order_data[:id]}",
      })
      return 
    end

    # it exists already somehow
    if Order.where(shopify_order_id: order_data[:id]).exists?
      EventLog.create_event!({
        type: "warning",
        internal_name: "Shopify::OrderCreateJob",
        group: "methods",
        controller: 'Shopify::OrderCreateJob',
        action: 'perform',
        params: { order: args },
        exception_message: "Order already exists, ID: #{order_data[:id]}",
      })
      return
    end

    order = Order.create_from_shopify_order!(order_data)
    ActiveJob::Base.logger.debug "New order:\n" + order.inspect
  end
end
