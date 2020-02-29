class CustomerAddress < ApplicationRecord
  acts_as_paranoid

  enum address_type: {shipping: 1, billing: 2, other: 3}
  validates :country, presence: true
  validates :country_code, presence: true
  # validates :shopify_address_id, presence: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :address1, presence: true
  # validates :city, presence: true
  
  def self.build_attributes_from_shopify_address(address_data, address_type = CustomerAddress.address_types[:other], add_origin_id = false)
    return nil if address_data.blank?
    attrs = {
      shopify_customer_id:address_data[:customer_id],
      address_type:       address_type,
      address1:           address_data[:address1],
      address2:           address_data[:address2],
      city:               address_data[:city],
      company:            address_data[:company],
      country:            address_data[:country],
      first_name:         address_data[:first_name],
      last_name:          address_data[:last_name],
      phone:              address_data[:phone],
      province:           address_data[:province],
      zip:                address_data[:zip],
      name:               address_data[:name],
      country_code:   CS.countries.key(address_data[:country]).to_s,
    }
    if add_origin_id
      raise BaseError.new("address id is empty") if address_data[:id].blank?
      attrs[:shopify_address_id] = address_data[:id]
    end
    attrs
  end
end
