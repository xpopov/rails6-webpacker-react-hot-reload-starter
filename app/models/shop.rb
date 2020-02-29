class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  def api_version
    ShopifyApp.configuration.api_version
  end

  def self.activate_installed_shop_session
    session = ShopifyAPI::Session.new({
      domain: self.current_shopify_domain, 
      token: self.current_shopify_token,
      api_version: ShopifyApp.configuration.api_version
    })
    ShopifyAPI::Base.activate_session(session)
  end

  def self.current_shopify_token
    last.try(:shopify_token) || ENV['SHOPIFY_API_TOKEN']
  end

  def self.current_shopify_domain
    last.try(:shopify_domain) || ENV['SHOPIFY_DOMAIN']
  end
end
