class Shopify::OrderUpdateJob < ApplicationJob
  queue_as :default
 
  def perform(args)
    shop_domain = args[:shop_domain]
    order_data = args[:order]
    action = args[:action] || ""

    # Allow some delay before existing order and shopify customer appears in our database
    retries = (max_delay / 0.5).round
    ActiveJob::Base.logger.debug "OrderUpdateJob##{order_data[:id]}: started"
    # customer_found = false
    order_found = false
    # all_products_found = false
    # all_variants_found = false
    # missing_product_id = nil
    # missing_variant_id = nil

    ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
      ActiveRecord::Base.connection.uncached do
        while retries > 0
          # customer_found ||= User.find_by_shopify_customer_id(order_data[:customer][:id]).present?
          order_found ||= Order.find_by_shopify_order_id(order_data[:id]).present?
          # ActiveJob::Base.logger.debug "Retrying #{retries}\n"
          # unless all_products_found
          #   missing_product_id = nil
          #   all_products_found_status = true
          #   order_data[:line_items].each do |li|
          #     all_products_found_status &&= li[:product_exists].blank? || Product.find_by_shopify_product_id(li[:product_id])
          #     missing_product_id = li[:product_id] unless all_products_found_status
          #     break unless all_products_found_status
          #   end
          #   all_products_found ||= all_products_found_status
          # end
          # unless all_variants_found
          #   missing_variant_id = nil
          #   all_variants_found_status = true
          #   order_data[:line_items].each do |li|
          #     all_variants_found_status &&= li[:product_exists].blank? || ProductVariant.find_by_shopify_variant_id(li[:variant_id])
          #     missing_variant_id = li[:variant_id] unless all_variants_found_status
          #     break unless all_variants_found_status
          #   end
          #   all_variants_found ||= all_variants_found_status
          # end
          break if order_found# && customer_found && all_products_found && all_variants_found
          sleep 0.5
          retries -= 1
        end
      end
    end

    # ActiveJob::Base.logger.error "OrderUpdateJob##{order_data[:id]}: No Shopify Customer found!!!" unless customer_found
    ActiveJob::Base.logger.error "OrderUpdateJob##{order_data[:id]}: No existing Order found!!!" unless order_found
    # ActiveJob::Base.logger.error "OrderUpdateJob##{order_data[:id]}: No Shopify Product found!!!" if missing_product_id.present?
    # ActiveJob::Base.logger.error "OrderUpdateJob##{order_data[:id]}: No Shopify Variant found!!!" if missing_variant_id.present?

    # raise ShopifyCustomerMissingError.new(order_data[:customer][:id], "OrderUpdateJob") unless customer_found
    raise ShopifyOrderMissingError.new(order_data[:id], "OrderUpdateJob") unless order_found
    # raise ShopifyProductMissingError.new(missing_product_id, "OrderUpdateJob") if missing_product_id.present?
    # raise ShopifyVariantMissingError.new(missing_variant_id, "OrderUpdateJob") if missing_variant_id.present?

    updated_order = Order.update_from_shopify_order!(order_data, "paid" == action ? 'payment' : false)
    ActiveJob::Base.logger.debug "OrderUpdateJob##{order_data[:id]} finished\n"

  end
end
