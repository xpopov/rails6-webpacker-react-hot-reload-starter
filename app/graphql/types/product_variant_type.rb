module Types
  class ProductVariantType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :handle, String, null: false
    field :price, String, null: true
    field :sku, String, null: true
    field :product_id, String, null: false
    field :created_at, String, null: true
    field :published_at, String, null: true
  end
end
