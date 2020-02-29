class ProductRetrievalService
  attr_accessor :products
  attr_accessor :variants

  def initialize
  end

  def perform
    initialize_session
    @products = fetch_products
    @variants = fetch_variants
    update_variants_fields
    @variants
  end

  private

  def initialize_session
    Shop.activate_installed_shop_session
  end

  def fetch_products
    ShopifyAPI::Product.all.map{ |p| [p.id, p] }.to_h
  end

  def fetch_variants
    ShopifyAPI::Variant.all.map{ |v| v.as_json.merge(product_id: v.product_id) }
  end

  def update_variants_fields
    @variants.each_with_index do |v, key|
      product = @products[v[:product_id]]
      if product.present?
        @variants[key]["product_title"] = product.title
        @variants[key]["handle"] = product.handle
        if v[:title] == "Default Title" || v[:title].blank?
          @variants[key]["title"] = product.title
        end
      end
    end
  end
end