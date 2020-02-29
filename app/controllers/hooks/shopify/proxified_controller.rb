class Hooks::Shopify::ProxifiedController < ApplicationController
  skip_forgery_protection

  # 'Host' => 'original.host',
  # 'X-Forwarded-For' => '34.69.176.120',
  # 'Connection' => 'close',
  # 'Content-Length' => '6452',
  # 'Content-Type' => 'application/json',
  # 'X-Shopify-Topic' => 'orders/create',
  # 'X-Shopify-Shop-Domain' => 'abc.myshopify.com',
  # 'X-Shopify-Order-Id' => '820982911946154508',
  # 'X-Shopify-Test' => 'true',
  # 'X-Shopify-Hmac-Sha256' => 'OL/a6+bgnfeSYExNq+v8Tn4rHtef/CrkcbIBpxsZtWM=',
  # 'X-Shopify-Api-Version' => '2019-10',
  # 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  # 'Accept' => '*/*',
  # 'User-Agent' => 'Ruby',

  # HTTP_X_SHOPIFY_API_VERSION
  # HTTP_X_SHOPIFY_HMAC_SHA256
  # HTTP_X_SHOPIFY_ORDER_ID
  # HTTP_X_SHOPIFY_SHOP_DOMAIN
  # HTTP_X_SHOPIFY_TEST
  # HTTP_X_SHOPIFY_TOPIC
  
  # send POST requests to corresponding webhooks
  def index
    # byebug
    # headers = request.headers.env.reject{ |key| key.to_s.include?('.') }
    # request.headers.map{ |k, v| Rails.logger.info k }
    headers = request.headers #.map{|v| v}
    # p headers
    Rails.logger.info request.headers['User-Agent']
    # Rails.logger.info headers.inspect
    Rails.logger.info request.raw_post
    topic = request.headers['HTTP_X_SHOPIFY_TOPIC']

    Rails.logger.info "Topic = #{topic}"

    Rails.logger.info headers.class.name
    # httparty and post to corresponding url:
    # headers = {}
    # ['CONTENT-LENGTH', 'USER-AGENT', 'ACCEPT',
    #   'ACCEPT-ENCODING', 'CONTENT-TYPE',
    #   'X-SHOPIFY-API-VERSION', 'X-SHOPIFY-HMAC-SHA256', 'X-SHOPIFY-ORDER-ID',
    #   'X-SHOPIFY-SHOP-DOMAIN', 'X-SHOPIFY-TEST', 'X-SHOPIFY-TOPIC'].each do |k|
    #   headers[k] = request.headers[k]
    # end
    # Rails.logger.info headers.inspect
    # headers = headers.select{ |k|  }
    url = ENV["SHOPIFY_WEBHOOK_PROXY_URL"] + "/hooks/shopify/#{topic}"
    # response = HTTParty.post(url, {
    #   headers: headers,
    #   body: request.raw_post,
    #   verify_peer: false,
    #   debug_output: STDOUT,
    # })
    # 
    # req = ActionDispatch::Request.new(request.env)
    # resp = ActionDispatch::Response.new
    # YourControllerClass.dispatch(:your_controller_method_name, req, resp)
    # render json: resp.body, status: resp.status

    # webhook_controller = Hooks::Shopify::OrdersController.new
    # webhook_controller.request = request
    # # webhook_controller.response = response
    # webhook_controller.process(:create)

    controller, action = topic.split("/")
    if controller == "orders"
      _request = ActionDispatch::Request.new(request.env)
      _response = ActionDispatch::Response.new
      Hooks::Shopify::OrdersController.dispatch(action.to_sym, _request, _response)
      render json: _response.body, status: _response.status
    end
  end
end
