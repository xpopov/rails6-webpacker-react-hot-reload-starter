FactoryBot.define do
  factory :shopify_customer_gdpr_request, class: OpenStruct do
    transient do
      _orders { [ Faker::Number.number(digits: 10).to_s, Faker::Number.number(digits: 10).to_s, Faker::Number.number(digits: 10).to_s ] }
    end
    shop_id { Faker::Number.number(digits: 10).to_s }
    shop_domain { "test.myshopify.com" }
    customer {
      {
        id: Faker::Number.number(digits: 10).to_s,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
      }
    }

    trait :redact do
      orders_to_redact { _orders }
    end

    trait :data_request do
      orders_requested { _orders }
    end

    after(:stub) do |req, evaluator|
      req.delete_field(:id)# if req.try(:id).present?
    end
  end
end
