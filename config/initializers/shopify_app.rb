ShopifyApp.configure do |config|
  config.application_name = "Newapp"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ""
  config.scope = "read_orders, write_orders, read_products, write_products, read_customers, write_customers, read_draft_orders, write_draft_orders, read_script_tags, write_script_tags, read_content, write_content, read_themes, write_themes"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2019-10"
  config.session_repository = Shop
  local = Rails.env.development?
  url = local ? "https://zsnvh0k14aze.runscope.net/" : ENV["SHOPIFY_WEBHOOK_PROXY_URL"] # "#{ENV['SHOPIFY_APP_URL']}/hooks/shopify/"
  config.webhooks = [
    # {topic: 'customers/redact',           address: url}, #"#{url}customers/redact"},
    # {topic: 'customers/data_request',     address: url}, #"#{url}customers/data_request"},

    {topic: 'orders/create',              address: url}, #"#{url}orders/create"},
    {topic: 'orders/delete',              address: url}, #"#{url}orders/delete"},
    {topic: 'orders/updated',             address: url}, #"#{url}orders/updated"},
    {topic: 'orders/cancelled',           address: url}, #"#{url}orders/cancelled"},
    {topic: 'orders/fulfilled',           address: url}, #"#{url}orders/fulfilled"},
    {topic: 'orders/paid',                address: url}, #"#{url}orders/paid"},
    {topic: 'orders/partially_fulfilled', address: url}, #"#{url}orders/partially_fulfilled"},

    # {topic: 'shop/redact',                address: url}, #"#{url}shop/redact"},
  ]
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known
