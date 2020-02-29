module WebhookTestHelper
  def deep_to_h(obj)
    # puts obj.class.name + "\n"
    if obj.is_a?(Array)
      res = obj.deep_dup
      res.each_with_index do |value, key|
        res[key] = deep_to_h(value) if value.present? && value.respond_to?(:to_h) # value.is_a? OpenStruct
      end
    else
      res = obj.to_h
      res.each do |key, value|
        res[key] = deep_to_h(value) if value.present? && value.respond_to?(:to_h) # value.is_a? OpenStruct
      end
    end
    res
  end

  def send_webhook(url, obj)
    data = deep_to_h(obj).to_json
    headers = {'HTTP_X_SHOPIFY_SHOP_DOMAIN': 'test.myshopify.com'}
    digest = OpenSSL::Digest.new('sha256')
    secret = ShopifyApp.configuration.secret
    hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
    headers["HTTP_X_SHOPIFY_HMAC_SHA256"] = hmac
    headers["CONTENT_TYPE"] = "application/json"
    post url, params: data, headers: headers
  end

  # def send_recharge_webhook(url, topic, data)
  #   data = deep_to_h(data).to_json
  #   headers = {'X-Shopify-Shop-Domain': 'test.myshopify.com'}
  #   digest = OpenSSL::Digest.new('sha256')
  #   secret = ShopifyApp.configuration.secret
  #   hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
  #   headers["X-Recharge-Hmac-Sha256"] = hmac
  #   headers["X-Recharge-Topic"] = topic
  #   headers["CONTENT_TYPE"] = "application/json"
  #   post url, params: data, headers: headers
  # end
end
