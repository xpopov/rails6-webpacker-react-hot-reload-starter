class Hooks::Shopify::ShopController < Hooks::Shopify::WebhookController

  def redact
    gdpr_request = build_gdpr_request(:redact)
    Shopify::ShopGdprRequestCreateJob.perform_later({shop_domain: shop_domain, gdpr_request: gdpr_request.to_h, type: "shop_redact"})
    head :ok
  end

  private

  def build_gdpr_request(type)
    recursive_delete_gids(gdpr_request_params(type).to_h.deep_symbolize_keys)
  end

  def gdpr_request_params(type)
    webhook_params.permit(:shop_id)
    webhook_params.permit(:shop_domain)
    webhook_params.slice(:shop_id, :shop_domain)
  end
end
