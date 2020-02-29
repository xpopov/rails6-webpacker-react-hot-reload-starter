class CreateCustomerAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_addresses do |t|
      t.string :shopify_address_id, index: true
      t.string :shopify_customer_id, index: true
      t.string :address1
      t.string :address2
      t.string :city
      t.string :company
      t.string :country, null: false
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :province
      t.string :zip
      t.string :name
      t.string :country_code, null: false
      t.integer :address_type, null: false, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
