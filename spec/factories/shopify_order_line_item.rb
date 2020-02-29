FactoryBot.define do
  factory :shopify_order_line_item, class: OpenStruct do
    transient do
      _total_discount { Faker::Commerce.price }
    end
    id { Faker::Number.number(digits: 10).to_s }
    variant_id { Faker::Number.number(digits: 10).to_s }
    title { Faker::Commerce.product_name }
    quantity { Faker::Number.between(from: 1, to: 3).to_i }
    price { Faker::Commerce.price(range: 20..99) }
    grams { Faker::Number.between(from: 1, to: 1000).to_i }
    sku { Faker::Commerce.promotion_code }
    variant_title { Faker::Commerce.promotion_code }
    vendor { "upscaled" }
    fulfillment_service { "manual" }
    product_id { Faker::Number.number(digits: 10).to_s }
    product_exists { true }
    taxable { true }
    name { Faker::Commerce.promotion_code }
    fulfillable_quantity { Faker::Number.between(from: 1, to: 3).to_i }
    total_discount { price - _total_discount > 10.0 ? _total_discount : 0 }
    fulfillment_status { [nil, "partial", "fulfilled"][Faker::Number.between(from: 0, to: 2).to_i] }

    trait :classic do
      name { "Classic" }
    end

    factory :shopify_order_line_item_classic, traits: [:classic]
  end
end
