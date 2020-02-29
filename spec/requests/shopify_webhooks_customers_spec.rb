require 'rails_helper'

RSpec.describe "Shopify webhooks for Customer", :type => :request do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let!(:new_customer) {
    build_stubbed(:shopify_customer)
  }

  before(:each) do
    # create(:scenario)
  end


  it "handles Shopify customer GDPR redact request and enqueues CustomerGdprRequestCreateJob" do
    ActiveJob::Base.queue_adapter = :test
    gdpr_request = build_stubbed(:shopify_customer_gdpr_request, :redact)
    # gdpr_request = CustomerGdprRequest.create_from_shopify_gdpr_request!()

    send_webhook(hooks_shopify_customers_redact_path, gdpr_request)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::CustomerGdprRequestCreateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", gdpr_request: gdpr_request.to_h, type: "customer_redact"}))
  end



  it "handles Shopify customer GDPR data_request request and enqueues CustomerGdprRequestCreateJob" do
    ActiveJob::Base.queue_adapter = :test
    gdpr_request = build_stubbed(:shopify_customer_gdpr_request, :data_request)
    # gdpr_request = CustomerGdprRequest.create_from_shopify_gdpr_request!()

    send_webhook(hooks_shopify_customers_data_request_path, gdpr_request)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::CustomerGdprRequestCreateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", gdpr_request: gdpr_request.to_h, type: "customer_data_request"}))
  end
end
