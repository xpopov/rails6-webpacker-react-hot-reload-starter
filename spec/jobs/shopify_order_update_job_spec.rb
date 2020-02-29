require 'rails_helper'

RSpec.describe "Shopify Order Update Job", :type => :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let!(:existing_order) {
    order = build_stubbed(:shopify_order)
    order
  }

  let!(:updated_order) {
    order = build_stubbed(:shopify_order)
    order.id = existing_order.id
    order
  }

  let!(:paid_order) {
    order = build_stubbed(:shopify_order, :paid)
    order.id = existing_order.id
    order
  }

  let!(:refunded_order) {
    order = build_stubbed(:shopify_order, :refunded)
    order.id = existing_order.id
    order
  }

  let(:some_customer) {
    # User.create_from_shopify_customer!(existing_order.customer)
    build_stubbed(:shopify_customer)
  }

  let(:some_order) {
    order = Order.create_from_shopify_order!(existing_order)
    order
  }

  let(:prepare_existing_order_for_update) {
    some_customer
    some_order
  }

  let(:prepare_existing_order_for_refund) {
    some_order = Order.create_from_shopify_order!(existing_order)
  }

  before(:each) do
    # create(:scenario)
  end

  after do
    clear_enqueued_jobs
  end

  it "updates existing order in the database", perform_enqueued: true do
    some_order = Order.create_from_shopify_order!(existing_order)
    some_order.shopify_customer_id = updated_order.customer.id
    
    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
    }.not_to change(Order, :count)
    
    order = Order.last

    expect(order.shopify_order_id).to eq updated_order.id
    expect(order.shopify_customer_id).to eq updated_order.customer.id
    expect(order.cancel_reason).to eq updated_order.cancel_reason
    expect(order.cancelled_at).to eq updated_order.cancelled_at
    expect(order.cancel_reason).to eq updated_order.cancel_reason
    expect(order.closed_at).to eq updated_order.closed_at
    expect(order.currency).to eq updated_order.currency
    expect(order.email).to eq updated_order.email
    expect(order.financial_status).to eq updated_order.financial_status
    expect(order.fulfillment_status).to eq updated_order.fulfillment_status
    expect(order.name).to eq updated_order.name
    expect(order.note).to eq updated_order.note
    expect(order.number).to eq updated_order.number
    expect(order.order_number).to eq updated_order.order_number
    expect(order.phone).to eq updated_order.phone
    expect(order.processed_at).to eq updated_order.processed_at
    expect(order.subtotal_price).to eq updated_order.subtotal_price.to_d
    expect(order.taxes_included).to eq updated_order.taxes_included
    expect(order.token).to eq updated_order.token
    expect(order.total_discounts).to eq updated_order.total_discounts.to_d
    expect(order.total_line_items_price).to eq updated_order.total_line_items_price.to_d
    expect(order.total_price).to eq updated_order.total_price.to_d
    expect(order.total_tax).to eq updated_order.total_tax.to_d
    expect(order.total_weight).to eq updated_order.total_weight
    expect(order.order_status_url).to eq updated_order.order_status_url
    expect(order.created_at).to eq updated_order.created_at
    expect(order.tags).to eq updated_order.tags

    # note_attributes are from the first order
    expect(order.note_attributes).to eq existing_order.note_attributes.map{ |na| [na.name, na.value] }.to_h

    billing_address_hash = order.billing_address.as_json.deep_symbolize_keys
    billing_address_hash.except!(:id, :shopify_address_id, :created_at, :updated_at, :deleted_at, :address_type, :from_date, :until_date, :shopify_customer_id, :temporary_shipping_address, :user_id, :source)
    expect(billing_address_hash).to eq updated_order.billing_address.to_h.except(:latitude, :longitude, :default, :country_name, :customer_id, :id, :province_code)

    shipping_address_hash = order.shipping_address.as_json.deep_symbolize_keys
    shipping_address_hash.except!(:id, :shopify_address_id, :created_at, :updated_at, :deleted_at, :address_type, :from_date, :until_date, :shopify_customer_id, :temporary_shipping_address, :user_id, :source)
    expect(shipping_address_hash).to eq updated_order.shipping_address.to_h.except(:latitude, :longitude, :default, :country_name, :customer_id, :id, :province_code)

    expect(order.line_items.count).to eq updated_order.line_items.count
    updated_order.line_items.sort_by!(&:id)
    order.line_items.sort_by(&:shopify_line_item_id).each_with_index do |line_item, i|
      # product = Product.find_by_shopify_product_id!(line_item.shopify_product_id)
      # product_variant = ProductVariant.find_by_shopify_variant_id!(line_item.shopify_variant_id)
      # expect(line_item.product).to eq                   product
      # expect(line_item.product_variant).to eq           product_variant
      expect(line_item.shopify_line_item_id).to eq      updated_order.line_items[i].id
      expect(line_item.shopify_product_id).to eq        updated_order.line_items[i].product_id
      expect(line_item.shopify_variant_id).to eq        updated_order.line_items[i].variant_id
      expect(line_item.title).to eq                     updated_order.line_items[i].title
      expect(line_item.quantity).to eq                  updated_order.line_items[i].quantity
      expect(line_item.price).to eq                     updated_order.line_items[i].price.to_d
      expect(line_item.grams).to eq                     updated_order.line_items[i].grams
      expect(line_item.sku).to eq                       updated_order.line_items[i].sku
      expect(line_item.variant_title).to eq             updated_order.line_items[i].variant_title
      expect(line_item.fulfillment_service).to eq       updated_order.line_items[i].fulfillment_service
      expect(line_item.fulfillable_quantity).to eq      updated_order.line_items[i].fulfillable_quantity
      expect(line_item.fulfillment_status).to eq        updated_order.line_items[i].fulfillment_status
    end

    # expect(order.tax_lines.count).to eq updated_order.tax_lines.count
    # updated_order.tax_lines.sort_by!(&:title)
    # order.tax_lines.sort_by(&:title).each_with_index do |tax_line, i|
    #   expect(tax_line.title).to eq updated_order.tax_lines[i].title
    #   expect(tax_line.price).to eq updated_order.tax_lines[i].price.to_d
    #   expect(tax_line.rate).to eq updated_order.tax_lines[i].rate.to_d
    # end
  end



  it "updates existing order in the database, even if product_exists=false", perform_enqueued: true do
    updated_order.line_items.each_with_index do |li, i|
      updated_order.line_items[i].product_id = nil
      updated_order.line_items[i].product_exists = false
    end
    some_order = Order.create_from_shopify_order!(existing_order)

    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
    }.not_to change(Order, :count)
    
    order = Order.last
    expect(order.shopify_order_id).to eq updated_order.id
    expect(order.shopify_customer_id).to eq updated_order.customer.id
    expect(order.line_items.count).to eq updated_order.line_items.count
  end



  it "updates existing order in the database, updating existing line_items", perform_enqueued: true do
    some_order = Order.create_from_shopify_order!(existing_order)
    updated_order.line_items = existing_order.line_items.deep_dup
    old_li_ids = some_order.line_items.map{ |li| li.id }.sort
    
    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
    }.not_to change(Order, :count)
    
    order = Order.last
    expect(order.shopify_order_id).to eq updated_order.id
    expect(order.shopify_customer_id).to eq updated_order.customer.id
    expect(order.line_items.count).to eq updated_order.line_items.count
    expect(order.line_items.map{ |li| li.id }.sort).to eq old_li_ids
  end

  

  it "updates existing order in the database if line_items are the same", perform_enqueued: true do
    some_order = Order.create_from_shopify_order!(existing_order)
    updated_order.line_items = existing_order.line_items
    some_order.shopify_order_id = updated_order.id
    some_order.save!

    updated_order.line_items = existing_order.line_items.deep_dup
    old_li_ids = some_order.line_items.map{ |li| li.id }.sort
    
    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
    }.not_to change(Order, :count)
    
    order = Order.last
    expect(order.shopify_order_id).to eq updated_order.id
    expect(order.shopify_customer_id).to eq updated_order.customer.id

    expect(order.line_items.count).to eq updated_order.line_items.count
    expect(order.line_items.map{ |li| li.id }.sort).to eq old_li_ids
  end



  # it "updates existing order in the database, updating existing tax_lines", perform_enqueued: true do
  #   some_user = User.create_from_shopify_customer!(existing_order.customer)
  #   some_order = Order.create_from_shopify_order!(existing_order)
    
  #   some_user.shopify_customer_id = updated_order.customer.id
  #   some_user.save!

  #   # some_order.line_items.each do |li|
  #     # li = li.deep_dup
  #   updated_order.tax_lines = existing_order.tax_lines.deep_dup
  #   old_tl_ids = some_order.tax_lines.map{ |tl| tl.id }.sort
    
  #   expect {
  #     Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
  #   }.not_to change(Order, :count)
    
  #   order = Order.last
  #   expect(order.user).to eq some_user
  #   expect(order.shopify_order_id).to eq updated_order.id
  #   expect(order.shopify_customer_id).to eq updated_order.customer.id

  #   expect(order.tax_lines.count).to eq updated_order.tax_lines.count
  #   expect(order.tax_lines.map{ |tl| tl.id }.sort).to eq old_tl_ids
  # end



  it "updates existing order in the database, updating refunds", perform_enqueued: true do
    some_order = prepare_existing_order_for_refund

    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(refunded_order)})
    }.not_to change(Order, :count)
    
    order = Order.last
    expect(JSON.parse(order.refunds, symbolize_names: true)).to eq deep_to_h(refunded_order.refunds)
  end



  # it "creates order_transactions and user_transactions, if action is 'paid'", perform_enqueued: true do
  #   create_users_preset

  #   recharge_order_data = build_stubbed(:recharge_order_data)
  #   recharge_order_data.shopify_order_id = updated_order.id
  #   recharge_order_data.line_items.first[:subscription_id] = subscription.recharge_id
  #   Recharge::Order.create_from_recharge_order!(recharge_order_data)

  #   prepare_existing_order_for_update
  #   allow(CreateUserTransactionsService).to receive(:new).and_call_original

  #   expect {
  #     Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order), action: "paid"})
  #   }.to change(OrderTransaction, :count).from(0).to(1)

  #   order = Order.last
  #   expect(order.shopify_order_id).to eq updated_order.id

  #   order_transaction = order.order_transactions.last
  #   expect(order_transaction.user_transactions.count). to eq 8 * some_order.line_items.count #8  users*<product count>

  #   # CreateUserTransactionsService was called
  #   expect(CreateUserTransactionsService).to have_received(:new).with(order_transaction).once
  # end



  it "does not fail when shipping and billing addresses are missing", perform_enqueued: true do
    some_order = Order.create_from_shopify_order!(existing_order)
    updated_order.billing_address = {}
    updated_order.shipping_address = {}

    expect {
      Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
    }.not_to raise_error

    order = Order.last
    expect(order.shopify_order_id).to eq updated_order.id
  end
end
