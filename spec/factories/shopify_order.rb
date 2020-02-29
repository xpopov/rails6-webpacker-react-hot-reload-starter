FactoryBot.define do
  factory :shopify_order, class: OpenStruct do
    transient do
      _line_items { build_list(:shopify_order_line_item, Faker::Number.between(from: 3, to: 6)) }
      _total_tax { Faker::Number.decimal(l_digits: 1).to_d.round(2) }
      _total_discounts { 0.to_d }
      _discount_codes { [] }
    end
    id { Faker::Number.number(digits: 10).to_s }
    cancel_reason { nil }
    cancelled_at { nil }
    # cart_token { nil }
    closed_at { nil }
    currency { "USD" }
    # user_id { Faker::Number.number(digits: 8).to_i }
    email { Faker::Internet.email }
    financial_status { "pending" }
    fulfillment_status { nil }
    name { '#' + (Faker::Number.number(digits: 2) + 1000).to_s }
    note { "some note" }
    number { (name.slice(1..-1).to_i - 1000).to_s }
    order_number { name.slice(1..-1) }
    phone { Faker::PhoneNumber.phone_number }
    processed_at { Faker::Time.between(from: 9.days.ago, to: Date.today).to_s }
    refunds { [] }
    subtotal_price { (line_items.sum{ |li| li.quantity * li.price } - _total_discounts).round(2).to_s }
    taxes_included { false }
    token { "940a393fed3a4d0cb1dc2858431e13e6" }
    total_discounts { _total_discounts.round(2).to_s }
    total_line_items_price { line_items.sum{ |li| li.quantity * li.price }.round(2).to_s }
    total_price { (subtotal_price.to_d + _total_tax.to_d).round(2).to_s }
    total_tax { _total_tax.round(2).to_s }
    total_weight { 0 }
    order_status_url { nil }
    note_attributes { [] }
    tags { "tag1, tag2" }
    created_at { Faker::Time.between(from: 10.days.ago, to: Date.today).to_s }
    updated_at { Faker::Time.between(from: 9.days.ago, to: Date.today).to_s }
    discount_codes { _discount_codes }
    processing_method { "checkout" }
    customer { create(:shopify_customer) }
    billing_address { create(:shopify_address) }
    shipping_address { create(:shopify_address) }
    line_items { _line_items }

    trait :paid do
      financial_status { "paid" }
    end

    trait :with_classic do
      transient do
        _line_items { build_list(:shopify_order_line_item_classic, 1) }
      end
    end

    trait :refunded do
      financial_status { "refunded" }
      refunds {
        [{
          id: Faker::Number.number(digits: 10).to_s,
          order_id: id,
          created_at: Faker::Time.between(from: 1.days.ago, to: Date.today).to_s,
          note: "",
          restock: nil,
          # user_id: user_id,
          processed_at: updated_at,
          refund_line_items: line_items,
          transactions: [
            {
              id: Faker::Number.number(digits: 10).to_s,
              order_id: id,
              amount: total_price.to_s,
              kind: "refund",
              gateway: "manual",
              status: "success",
              message: "Refunded #{total_price.to_d} from manual gateway",
              created_at: Faker::Time.between(from: 1.days.ago, to: Date.today).to_s,
              test: false,
              authorization: nil,
              currency: "ILS",
              location_id: nil,
              user_id: nil,
              parent_id: Faker::Number.number(digits: 10).to_s,
              device_id: nil,
              receipt: {},
              error_code: nil,
              source_name: "web"
            }
          ],
          order_adjustments: []
        }]
      }
    end

    after(:build) do |order|
    end

    factory :shopify_order_paid, traits: [:paid]
    factory :shopify_order_with_classic, traits: [:with_classic]
    factory :shopify_order_paid_with_classic, traits: [:paid, :with_classic]
  end
end
