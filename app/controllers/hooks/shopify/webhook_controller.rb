class Hooks::Shopify::WebhookController < ActionController::Base
  protect_from_forgery with: :exception
  include ShopifyApp::WebhookVerification
  include Response
  include ExceptionHandler

  def webhook_params
    return @_webhook_params if @_webhook_params.present?
    params.try(:permit!)
    @_webhook_params = params.except(:controller, :action, :type)
  end
  
  def recursive_delete_gids(hash)
    hash.each do |key, value|
      case value
      when String
        hash.delete(key) if value.start_with? 'gid://'
      when Hash
        recursive_delete_gids(value)
      when Array
        value.each do |array_value|
          recursive_delete_gids(array_value) if array_value.is_a? Hash
        end
      end
    end
  end

end