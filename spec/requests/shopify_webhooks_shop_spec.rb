require 'rails_helper'

RSpec.describe "Shopify webhooks for Shop", :type => :request do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  it "handles Shopify Shop GDPR redact request and enqueues ShopGdprRequestCreateJob" do
    ActiveJob::Base.queue_adapter = :test
    gdpr_request = build_stubbed(:shopify_shop_gdpr_request)

    send_webhook(hooks_shopify_shop_redact_path, gdpr_request)
    expect(response).to be_successful
    expect(response.body).to be_empty

    expect(Shopify::ShopGdprRequestCreateJob).to(
      have_been_enqueued.with({shop_domain: "test.myshopify.com", gdpr_request: gdpr_request.to_h, type: "shop_redact"}))
  end
end
