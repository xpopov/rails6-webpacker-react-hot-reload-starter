module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :order_number, String, null: false
    field :created_at, String, null: true
    field :shopify_order_id, String, null: false
    field :shopify_customer_id, String, null: false
    field :number, String, null: false
    field :email, String, null: false
    field :name, String, null: true
    field :total_price, String, null: true
    field :status, String, null: false

    def status
      object.financial_status.capitalize
    end
  end
end
