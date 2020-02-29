require 'rails_helper'

RSpec.describe "Shopify webhooks for Order", :type => :request do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let!(:shopify_order) {
    build_stubbed(:shopify_order)
  }
  let!(:shopify_customer) {
    build_stubbed(:shopify_customer)
  }
  let!(:order_params) {
    order = shopify_order
  }
  let!(:order_hash) {
    deep_to_h(shopify_order)
  }

  before(:each) do
  end


  it "handles Shopify order creation and enqueues OrderCreateJob" do
    ActiveJob::Base.queue_adapter = :test
    send_webhook(hooks_shopify_orders_create_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderCreateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
  end



  context "when shipping and billing addresses are missing" do
    before {
      shopify_order.shipping_address = {}
      shopify_order.billing_address = {}
    }
    it "succeed to enqueue OrderCreateJob" do
      ActiveJob::Base.queue_adapter = :test
      send_webhook(hooks_shopify_orders_create_path, order_params)
      expect(response).to be_successful
      expect(response.body).to be_empty

      order_hash = deep_to_h(shopify_order)
      expect(Shopify::OrderCreateJob).to(
        have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
    end
    it "succeed to enqueue OrderUpdateJob" do
      ActiveJob::Base.queue_adapter = :test
      send_webhook(hooks_shopify_orders_updated_path, order_params)
      expect(response).to be_successful
      expect(response.body).to be_empty

      order_hash = deep_to_h(shopify_order)
      expect(Shopify::OrderUpdateJob).to(
        have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
    end
  end



  it "handles Shopify order update and enqueues OrderUpdateJob" do
    ActiveJob::Base.queue_adapter = :test

    send_webhook(hooks_shopify_orders_updated_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderUpdateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
  end



  it "handles Shopify order deletion and enqueues OrderDeleteJob" do
    ActiveJob::Base.queue_adapter = :test
    deleted_order = { id: Faker::Number.number(digits: 10).to_s }

    send_webhook(hooks_shopify_orders_delete_path, deleted_order)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderDeleteJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: deleted_order.to_h}))
  end



  it "handles Shopify order cancellation and enqueues OrderUpdateJob" do
    ActiveJob::Base.queue_adapter = :test
    # cancelled_order = build_stubbed(:shopify_order)

    send_webhook(hooks_shopify_orders_cancelled_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderUpdateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
  end



  it "handles Shopify order fulfilled and enqueues OrderUpdateJob" do
    ActiveJob::Base.queue_adapter = :test
    # fulfilled_order = build_stubbed(:shopify_order)

    send_webhook(hooks_shopify_orders_fulfilled_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderUpdateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
  end



  it "handles Shopify order partial fulfillment and enqueues OrderUpdateJob" do
    ActiveJob::Base.queue_adapter = :test
    # fulfilled_order = build_stubbed(:shopify_order)

    send_webhook(hooks_shopify_orders_partially_fulfilled_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderUpdateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash}))
  end



  it "handles Shopify order payment and enqueues OrderUpdateJob" do
    ActiveJob::Base.queue_adapter = :test
    # paid_order = build_stubbed(:shopify_order)

    send_webhook(hooks_shopify_orders_paid_path, order_params)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::OrderUpdateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", order: order_hash, action: "paid"}))
  end

end
