Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  root 'test#index'
  get "/orders", to: "test#index"
  get "/settings", to: "test#index"
  post "/graphql", to: "graphql#execute"

  namespace :hooks do
    namespace :shopify do
      match "proxified", via: [:post], to: "proxified#index"
      # match "customers/create", via: [:get, :post], to: "customers#create"
      # match "customers/update", via: [:get, :post], to: "customers#update"
      # match "customers/delete", via: [:get, :post], to: "customers#delete"
      # match "customers/enable", via: [:get, :post], to: "customers#enable"
      # match "customers/disable", via: [:get, :post], to: "customers#disable"
      match "customers/redact", via: [:post], to: "customers#redact"
      match "customers/data_request", via: [:post], to: "customers#data_request"

      match "orders/create", via: [:get, :post], to: "orders#create"
      match "orders/delete", via: [:get, :post], to: "orders#delete"
      match "orders/updated", via: [:get, :post], to: "orders#updated"
      match "orders/cancelled", via: [:get, :post], to: "orders#cancelled"
      match "orders/fulfilled", via: [:get, :post], to: "orders#fulfilled"
      match "orders/paid", via: [:get, :post], to: "orders#paid"
      match "orders/partially_fulfilled", via: [:get, :post], to: "orders#partially_fulfilled"

      # match "products/create", via: [:get, :post], to: "products#create"
      # match "products/delete", via: [:get, :post], to: "products#delete"
      # match "products/update", via: [:get, :post], to: "products#update"

      match "shop/redact", via: [:post], to: "shop#redact"
    end
  end
end
