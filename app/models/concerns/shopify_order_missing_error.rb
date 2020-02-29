class ShopifyOrderMissingError < BaseError
  def initialize(id, source = nil)
    super "Shopify Order ##{id} is missing", source
  end
end
