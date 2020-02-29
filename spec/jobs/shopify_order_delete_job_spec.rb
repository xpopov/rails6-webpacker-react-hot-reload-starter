require 'rails_helper'

# BigDecimal.mode(BigDecimal::ROUND_MODE, BigDecimal::ROUND_HALF_EVEN)
# BigDecimal.limit(20)

RSpec.describe "Shopify Order Delete Job", :type => :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let!(:shopify_existing_order) {
    order = build_stubbed(:shopify_order)
    order.line_items.each do |li|
      # product = Product.create_from_shopify_product!(build_stubbed(:shopify_product))
      # product.shopify_product_id = li[:product_id]
      # product.save!
      # product.variants.first.update_attributes!(shopify_variant_id: li[:variant_id])
      # Inventory.create!(product_variant_id: product.variants.first.id, location_id: location.id, quantity: li[:quantity])
    end
    order
  }

  before(:each) do
    # create(:scenario)
  end  

  after do
    clear_enqueued_jobs
  end

  it "marks corresponding order in the database as deleted", perform_enqueued: true do
    deleted_order = { id: Faker::Number.number(digits: 8).to_i }
    existing_order = Order.create_from_shopify_order!(shopify_existing_order)
    existing_order.shopify_order_id = deleted_order[:id]
    existing_order.save!
    
    expect {
      Shopify::OrderDeleteJob.perform_later({shop_domain: "test.myshopify.com", order: deleted_order.to_h})
    }.to change(Order, :count).by(-1)

    # We cannot find it anymore    
    expect {
      Order.find_by_shopify_order_id!(deleted_order[:id])
    }.to raise_error ActiveRecord::RecordNotFound

    # But it's among deleted records
    expect {
      order = Order.with_deleted.find_by_shopify_order_id!(deleted_order[:id])
      expect(order.deleted_at).to be_present
    }.not_to raise_error
  end

  it "fails when deleted shopify order is not in our database", perform_enqueued: true do
    deleted_order = { id: Faker::Number.number(digits: 8).to_i }
    expect {
      Shopify::OrderDeleteJob.perform_later({shop_domain: "test.myshopify.com", order: deleted_order.to_h})
    }.to raise_error ShopifyOrderMissingError
  end

end
