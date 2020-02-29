module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :orders, [Types::OrderType], null: false, description: "Shopify Orders" do
      argument :selection, String, required: true
      argument :page, Integer, required: false, default_value: 0
      argument :limit, Integer, required: false, default_value: 50
    end

    field :clients, [Types::ClientType], null: false, description: "Clients" do
      argument :page, Integer, required: false, default_value: 0
      argument :limit, Integer, required: false, default_value: 50
    end

    field :client, ClientType, null: true do
      description "Find Client by ID"
      argument :id, ID, required: true
    end

    field :product_variants, [Types::ProductVariantType], null: false, description: "Shopify Variants"

    field :settings, Types::Settings, null: false, description: "Settings as payload"

    field :dashboard_status, Types::DashboardStatus, null: false, description: "Dashboard data"
    
    def orders(params)
      page = params[:page]
      limit = params[:limit]
      selection = params[:selection]
      scoped_orders = Order.public_send selection
      scoped_orders.order(created_at: :desc).offset(page * limit).limit(limit)
    end

    def clients(params)
      page = params[:page]
      limit = params[:limit]
      Client.order(created_at: :desc).offset(page * limit).limit(limit)
    end

    def client(id:)
      Client.find(id)
    end

    def product_variants
      # pull from Shopify
      ProductRetrievalService.new.perform
    end

    def settings
      Setting.get_payload
    end

    def dashboard_status
      Order.dashboard_status
    end
  end
end
