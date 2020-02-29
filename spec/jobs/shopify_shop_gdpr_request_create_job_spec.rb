require 'rails_helper'

RSpec.describe "Shopify Shop GDPR Request Create Job", :type => :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  let(:new_gdpr_redact_request) {
    build_stubbed(:shopify_shop_gdpr_request)
  }

  before do
  end

  context "when type is redact" do
    it "creates new request in the database", perform_enqueued: true do
      expect {
        Shopify::ShopGdprRequestCreateJob.perform_later({shop_domain: "test.myshopify.com", gdpr_request: new_gdpr_redact_request.to_h, type: "shop_redact"})
      }.to change(GdprRequest, :count).by(1)
      .and change(EventLog, :count).by(1)
      .and change(ActionMailer::Base.deliveries, :size).by(1)
      
      request = GdprRequest.last
      expect(request.shop_id).to eq new_gdpr_redact_request[:shop_id]
      expect(request.shop_domain).to eq new_gdpr_redact_request[:shop_domain]
      expect(request.shopify_customer_id).to be_blank
      expect(request.email).to be_blank
      expect(request.phone).to be_blank
      expect(request.orders).to be_blank
      expect(request.type).to eq "shop_redact"

      event = EventLog.last
      expect(event.group).to eq "gdpr_requests"
    end
  end

end
