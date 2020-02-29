class GdprRequest < ApplicationRecord
  self.inheritance_column = "type_not_used"
  serialize :orders, Array
  after_initialize :initialize_orders

  validates_presence_of :shop_id, :shop_domain, :type

  enum type: {
    customer_redact:               "customer_redact",
    customer_data_request:         "customer_data_request",
    shop_redact:                   "shop_redact",
  }

  def self.create_from_shopify_data!(shopify_data, type)
    attrs = shopify_data.except(:customer, :orders_to_redact, :orders_requested)
    if type != "shop_redact"
      attrs[:shopify_customer_id] = shopify_data[:customer][:id]
      attrs[:email] = shopify_data[:customer][:email]
      attrs[:phone] = shopify_data[:customer][:phone]
      attrs[:orders] = shopify_data[type == "customer_redact" ? :orders_to_redact : :orders_requested]
    end
    attrs[:type] = type.to_sym
    request = self.create! attrs
    request.create_event_log
  end

  def initialize_orders
    self.orders = [] if self.orders.blank?
  end

  def create_event_log
    EventLog.create_event!({
      type: "notice",
      internal_name: self.class.to_s,
      group: "gdpr_requests",
      controller: self.class.to_s,
      params: self.to_json,
    })
  end

end