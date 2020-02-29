FactoryBot.define do
  factory :shopify_shop_gdpr_request, class: OpenStruct do
    shop_id { Faker::Number.number(digits: 10).to_s }
    shop_domain { "test.myshopify.com" }

    after(:stub) do |req, evaluator|
      req.delete_field(:id)# if req.try(:id).present?
    end
  end
end
