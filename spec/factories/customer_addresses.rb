FactoryBot.define do
  factory :customer_address, class: OpenStruct do
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
    first_name { Faker::Name.first_name }
    address1 { _address.street_address }
    phone { Faker::PhoneNumber.cell_phone }
    city { _address.city }
    zip { _address.zip_code }
    province {
      states = CS.states(_country_code)
      states.present? ? states[_state_code] : ''
    }
    country { CS.countries[_country_code] }
    last_name { Faker::Name.last_name }
    address2 { _address.secondary_address }
    company { Faker::Company.name }
    latitude { nil }
    longitude { nil }
    name { first_name + " " + last_name  }
    # country_code { _country_code.to_s }
    country_iso_code { _country_code.to_s }
  end
end
