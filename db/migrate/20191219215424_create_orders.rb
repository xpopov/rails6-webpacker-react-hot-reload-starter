class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :shopify_order_id, null: false, index: true
      t.integer :billing_address_id, index: true
      t.integer :shipping_address_id, index: true
      t.string :cancel_reason
      t.datetime :cancelled_at
      t.datetime :closed_at
      t.string :currency, null: false
      t.string :shopify_customer_id, null: false
      t.string :email, null: false
      t.string :financial_status
      t.string :fulfillment_status
      t.string :name, null: false
      t.text :note
      t.string :number, null: false
      t.string :order_number, null: false
      t.string :phone
      t.datetime :processed_at
      t.string :refunds
      t.decimal :subtotal_price, precision: 8, scale: 2, null: false
      t.boolean :taxes_included
      t.string :token
      t.decimal :total_discounts, precision: 8, scale: 2
      t.decimal :total_line_items_price, precision: 8, scale: 2, null: false
      t.decimal :total_price, precision: 8, scale: 2, null: false
      t.decimal :total_tax, precision: 8, scale: 2
      t.integer :total_weight
      t.string :order_status_url
      t.datetime :deleted_at
      t.text :note_attributes
      t.string :tags

      t.timestamps
    end
  end
end
