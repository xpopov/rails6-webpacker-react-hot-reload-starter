class CreateOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :shopify_line_item_id, null: false
      t.decimal :price, precision: 8, scale: 2
      t.string :shopify_product_id
      t.integer :quantity, null: false
      t.string :name, null: false
      t.string :sku
      t.integer :grams
      t.string :title, null: false
      t.string :shopify_variant_id
      t.string :variant_title
      t.integer :fulfillable_quantity
      t.string  :fulfillment_service
      t.string  :fulfillment_status
      t.boolean :product_exists
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
