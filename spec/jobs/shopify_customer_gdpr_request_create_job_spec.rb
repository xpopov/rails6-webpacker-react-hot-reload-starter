require 'rails_helper'

RSpec.describe "Shopify Customer GDPR Request Create Job", :type => :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let(:new_gdpr_redact_request) {
    build_stubbed(:shopify_customer_gdpr_request, :redact)
  }

  let(:new_gdpr_data_request_request) {
    build_stubbed(:shopify_customer_gdpr_request, :data_request)
  }

  before do
  end

  context "when type is redact" do
    it "creates new request in the database", perform_enqueued: true do
      expect {
        Shopify::CustomerGdprRequestCreateJob.perform_later({shop_domain: "test.myshopify.com", gdpr_request: new_gdpr_redact_request.to_h, type: "customer_redact"})
      }.to change(GdprRequest, :count).by(1)
      .and change(EventLog, :count).by(1)
      
      request = GdprRequest.last
      expect(request.shop_id).to eq new_gdpr_redact_request[:shop_id]
      expect(request.shop_domain).to eq new_gdpr_redact_request[:shop_domain]
      expect(request.shopify_customer_id).to eq new_gdpr_redact_request[:customer][:id]
      expect(request.email).to eq new_gdpr_redact_request[:customer][:email]
      expect(request.phone).to eq new_gdpr_redact_request[:customer][:phone]
      expect(request.orders).to eq new_gdpr_redact_request[:orders_to_redact]
      expect(request.type).to eq "customer_redact"
    end
  end

  context "when type is data_request" do
    it "creates new request in the database", perform_enqueued: true do
      expect {
        Shopify::CustomerGdprRequestCreateJob.perform_later({shop_domain: "test.myshopify.com", gdpr_request: new_gdpr_data_request_request.to_h, type: "customer_data_request"})
      }.to change(GdprRequest, :count).by(1)
      .and change(EventLog, :count).by(1)
      
      request = GdprRequest.last
      expect(request.shop_id).to eq new_gdpr_data_request_request[:shop_id]
      expect(request.shop_domain).to eq new_gdpr_data_request_request[:shop_domain]
      expect(request.shopify_customer_id).to eq new_gdpr_data_request_request[:customer][:id]
      expect(request.email).to eq new_gdpr_data_request_request[:customer][:email]
      expect(request.phone).to eq new_gdpr_data_request_request[:customer][:phone]
      expect(request.orders).to eq new_gdpr_data_request_request[:orders_requested]
      expect(request.type).to eq "customer_data_request"

      event = EventLog.last
      expect(event.group).to eq "gdpr_requests"
    end
  end

end
