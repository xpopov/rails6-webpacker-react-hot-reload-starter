FactoryBot.define do
  factory :shopify_address, class: OpenStruct do
    transient do
      _address { Faker::Address }
      _country_index { 
        Random.rand(CS.countries.count)
      }
      _country_code { 
        # puts CS.countries.keys[_country_index].to_s
        CS.countries.keys[_country_index]
      }
      _state_code {
        states = CS.states(_country_code)
        states.present? ? states.keys[Random.rand(states.count)] : ''
      }
    end
    id { Faker::Number.number(digits: 8).to_s }
    customer_id { Faker::Number.number(digits: 8).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    company { Faker::Company.name }
    address1 { _address.street_address }
    address2 { _address.secondary_address }
    city { _address.city }
    province {
      states = CS.states(_country_code)
      states.present? ? states[_state_code] : ''
    }
    country { CS.countries[_country_code] }
    zip { _address.zip_code }
    phone { Faker::PhoneNumber.cell_phone }
    name { first_name + " " + last_name  }
    province_code { _state_code.to_s }
    country_code { _country_code.to_s }
    country_name { CS.countries[_country_code] }
    default { true }
  end
end
