FactoryBot.define do
  factory :shopify_customer, class: OpenStruct do
    transient do
      _addresses { build_list(:shopify_address, Faker::Number.between(from:1, to: 3)) }
    end

    id { Faker::Number.number(digits: 8).to_s }
    email { Faker::Internet.email }
    accepts_marketing { true }
    created_at { Faker::Time.between(from:10.days.ago, to: Date.today).to_s }
    updated_at { Faker::Time.between(from:10.days.ago, to: Date.today).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    orders_count { Faker::Number.number(digits: 2).to_i }
    state { "enabled" }
    total_spent { Faker::Number.decimal(l_digits: 2).to_f }
    last_order_id { Faker::Number.number(digits: 2).to_i }
    note { "some note" }
    verified_email { true }
    multipass_identifier { nil }
    tax_exempt { false }
    phone { "+9-#{Faker::PhoneNumber.subscriber_number(length: 3)}-#{Faker::PhoneNumber.subscriber_number(length: 3)}-#{Faker::PhoneNumber.extension}" }
    tags { "" }
    last_order_name { "some order" }
    addresses { _addresses }
    default_address { _addresses.first }
  end
end
