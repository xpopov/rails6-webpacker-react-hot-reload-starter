class CreateGdprRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :gdpr_requests do |t|
      t.string :shop_id, null: false
      t.string :shop_domain, null: false
      t.string :shopify_customer_id
      t.string :email
      t.string :phone
      t.string :type
      t.text   :orders, array: true
      t.timestamps
    end
  end
end
