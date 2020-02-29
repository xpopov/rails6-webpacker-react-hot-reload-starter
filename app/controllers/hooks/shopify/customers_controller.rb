class Hooks::Shopify::CustomersController < Hooks::Shopify::WebhookController
  def redact
    gdpr_request = build_gdpr_request(:redact)
    Shopify::CustomerGdprRequestCreateJob.perform_later({shop_domain: shop_domain, gdpr_request: gdpr_request.to_h, type: "customer_redact"})
    head :ok
  end

  def data_request
    gdpr_request = build_gdpr_request(:data_request)
    Shopify::CustomerGdprRequestCreateJob.perform_later({shop_domain: shop_domain, gdpr_request: gdpr_request.to_h, type: "customer_data_request"})
    head :ok
  end

  private

  def build_gdpr_request(type)
    recursive_delete_gids(gdpr_request_params(type).to_h.deep_symbolize_keys)
  end
  
  def gdpr_request_params(type)
    webhook_params.permit(:shop_id)
    webhook_params.permit(:shop_domain)
    webhook_params.require(:customer).permit(:id)
    webhook_params.require(:customer).permit(:email)
    webhook_params.require(:customer).permit(:phone)
    webhook_params.permit(:orders_to_redact) if type == :redact
    webhook_params.permit(:orders_requested) if type == :data_request
    webhook_params.slice(:shop_id, :shop_domain, :customer, type == :redact ? :orders_to_redact : :orders_requested)
  end
end
