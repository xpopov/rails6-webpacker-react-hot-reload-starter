class Shopify::ShopGdprRequestCreateJob < ApplicationJob
  queue_as :default
 
  def perform(args)
    shop_domain = args[:shop_domain]
    shopify_gdpr_request = args[:gdpr_request]
    GdprRequest.create_from_shopify_data!(shopify_gdpr_request, args[:type])
  end
end
