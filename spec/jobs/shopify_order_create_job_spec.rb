require 'rails_helper'

# BigDecimal.mode(BigDecimal::ROUND_MODE, BigDecimal::ROUND_HALF_EVEN)
# BigDecimal.limit(20)

RSpec.describe "Shopify Order Create Job", type: :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let!(:new_order) {
    new_order = build_stubbed(:shopify_order)
    new_order.line_items.each_with_index do |li, index|
      # product = Product.create_from_shopify_product!(build_stubbed(:shopify_product))
      # product.shopify_product_id = li[:product_id]
      # product.save!
      # product.variants.first.update_attributes!(shopify_variant_id: li[:variant_id])
      # Inventory.create!(product_variant_id: product.variants.first.id, location_id: location.id, quantity: li[:quantity])
    end
    new_order
  }

  before(:each) do
    # create(:scenario)
  end  

  after do
    clear_enqueued_jobs
  end

  it "creates new order in the database", perform_enqueued: true do
    expect {
      Shopify::OrderCreateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(new_order)})
    }.to change(Order, :count).by(1)
    
    order = Order.last

    expect(order.shopify_order_id).to eq new_order.id
    expect(order.shopify_customer_id).to eq new_order.customer.id
    expect(order.cancel_reason).to eq new_order.cancel_reason
    expect(order.cancelled_at).to eq new_order.cancelled_at
    expect(order.cancel_reason).to eq new_order.cancel_reason
    expect(order.closed_at).to eq new_order.closed_at
    expect(order.currency).to eq new_order.currency
    expect(order.email).to eq new_order.email
    expect(order.financial_status).to eq new_order.financial_status
    expect(order.fulfillment_status).to eq new_order.fulfillment_status
    expect(order.name).to eq new_order.name
    expect(order.note).to eq new_order.note
    expect(order.number).to eq new_order.number
    expect(order.order_number).to eq new_order.order_number
    expect(order.phone).to eq new_order.phone
    expect(order.processed_at).to eq new_order.processed_at
    expect(order.subtotal_price.to_d).to eq new_order.subtotal_price.to_d
    expect(order.taxes_included).to eq new_order.taxes_included
    expect(order.token).to eq new_order.token
    expect(order.total_discounts).to eq new_order.total_discounts.to_d
    expect(order.total_line_items_price).to eq new_order.total_line_items_price.to_d
    expect(order.total_price).to eq new_order.total_price.to_d
    expect(order.total_tax).to eq new_order.total_tax.to_d
    expect(order.total_weight).to eq new_order.total_weight
    expect(order.order_status_url).to eq new_order.order_status_url
    expect(order.created_at).to eq new_order.created_at
    # expect(order.updated_at).to eq new_order.updated_at
    expect(order.tags).to eq new_order.tags

    expect(order.note_attributes).to eq new_order.note_attributes.map{ |na| [na.name, na.value] }.to_h

    billing_address_hash = order.billing_address.as_json.deep_symbolize_keys
    billing_address_hash.except!(:id, :shopify_address_id, :created_at, :updated_at, :deleted_at, :address_type, :from_date, :until_date, :shopify_customer_id, :temporary_shipping_address, :user_id, :source)
    expect(billing_address_hash).to eq new_order.billing_address.to_h.except(:latitude, :longitude, :default, :country_name, :customer_id, :id, :province_code)

    shipping_address_hash = order.shipping_address.as_json.deep_symbolize_keys
    shipping_address_hash.except!(:id, :shopify_address_id, :created_at, :updated_at, :deleted_at, :address_type, :from_date, :until_date, :shopify_customer_id, :temporary_shipping_address, :user_id, :source)
    expect(shipping_address_hash).to eq new_order.shipping_address.to_h.except(:latitude, :longitude, :default, :country_name, :customer_id, :id, :province_code)

    expect(order.line_items.count).to eq new_order.line_items.count
    new_order.line_items.sort_by!(&:id)
    order.line_items.sort_by(&:shopify_line_item_id).each_with_index do |line_item, i|
      # product = Product.find_by_shopify_product_id!(line_item.shopify_product_id)
      # product_variant = ProductVariant.find_by_shopify_variant_id!(line_item.shopify_variant_id)
      # expect(line_item.product).to eq                   product
      # expect(line_item.product_variant).to eq           product_variant
      expect(line_item.shopify_line_item_id).to eq      new_order.line_items[i].id
      expect(line_item.shopify_product_id).to eq        new_order.line_items[i].product_id
      expect(line_item.shopify_variant_id).to eq        new_order.line_items[i].variant_id
      expect(line_item.title).to eq                     new_order.line_items[i].title
      expect(line_item.quantity).to eq                  new_order.line_items[i].quantity
      expect(line_item.price).to eq                     new_order.line_items[i].price.to_d
      expect(line_item.grams).to eq                     new_order.line_items[i].grams
      expect(line_item.sku).to eq                       new_order.line_items[i].sku
      expect(line_item.variant_title).to eq             new_order.line_items[i].variant_title
      expect(line_item.fulfillment_service).to eq       new_order.line_items[i].fulfillment_service
      expect(line_item.fulfillable_quantity).to eq      new_order.line_items[i].fulfillable_quantity
      expect(line_item.fulfillment_status).to eq        new_order.line_items[i].fulfillment_status
    end

    # expect(order.tax_lines.count).to eq new_order.tax_lines.count
    # new_order.tax_lines.sort_by!(&:title)
    # order.tax_lines.sort_by(&:title).each_with_index do |tax_line, i|
    #   expect(tax_line.title).to eq new_order.tax_lines[i].title
    #   expect(tax_line.price).to eq new_order.tax_lines[i].price.to_d
    #   expect(tax_line.rate).to eq new_order.tax_lines[i].rate.to_d
    # end
  end
end
