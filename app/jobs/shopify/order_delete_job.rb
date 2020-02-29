class Shopify::OrderDeleteJob < ApplicationJob
  queue_as :default
 
  def perform(args)
    shop_domain = args[:shop_domain]
    order_data = args[:order]

    order = Order.find_by_shopify_order_id(order_data[:id])
    if order.blank?
      ActiveJob::Base.logger.error "OrderDeleteJob##{order_data[:id]}: No Shopify Order found!!!"
      raise ShopifyOrderMissingError.new(order_data[:id], "OrderDeleteJob")
    end
    order.destroy!
  end
end
