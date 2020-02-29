class OrderLineItem < ApplicationRecord
  acts_as_paranoid dependent_recovery_window: 14.day
  belongs_to :order, inverse_of: :line_items
  # belongs_to :product
  # belongs_to :product_variant
  # fulfillable_quantity - max quantity that can be filfilled

  validates :order, presence: true
  # validates :product, presence: true, if: :product_exists #could be empty, see shopify lineitem's :product_exists attribute
  validates :shopify_product_id, presence: true, if: :product_exists
  # validates :product_variant, presence: true, if: :product_exists
  validates :shopify_variant_id, presence: true, if: :product_exists
  validates :name, presence: true
  #not unique - duplicates if order was Duplicated from Shopify UI
  validates :shopify_line_item_id, presence: true#, uniqueness: true  
  # validates :sku, presence: true
  validates :title, presence: true
  # validates :variant_title, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.build_attributes_from_shopify_line_item(line_item_data)
    {
      # product:              line_item_data[:product_exists] ?
      #   Product.find_by_shopify_product_id!(line_item_data[:product_id]) :
      #   Product.find_by_shopify_product_id(line_item_data[:product_id]),
      # product_variant:      line_item_data[:product_exists] ?
      #   ProductVariant.find_by_shopify_variant_id!(line_item_data[:variant_id]) :
      #   ProductVariant.find_by_shopify_variant_id(line_item_data[:variant_id]),
      shopify_line_item_id: line_item_data[:id],
      shopify_variant_id:   line_item_data[:variant_id],
      title:                line_item_data[:title],
      quantity:             line_item_data[:quantity],
      price:                line_item_data[:price],
      grams:                line_item_data[:grams],
      sku:                  line_item_data[:sku],
      variant_title:        line_item_data[:variant_title],
      fulfillment_service:  line_item_data[:fulfillment_service],
      fulfillable_quantity: line_item_data[:fulfillable_quantity],
      fulfillment_status:   line_item_data[:fulfillment_status],
      shopify_product_id:   line_item_data[:product_id],
      name:                 line_item_data[:name],
      product_exists:       line_item_data[:product_exists],
    }
  end

end
