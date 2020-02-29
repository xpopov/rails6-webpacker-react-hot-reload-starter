namespace :shopify do
  desc "Sync Orders"
  # arguments order_id,ignore_errors
  # could be just order_id(string/integer), or just ignore_errors(boolean)
  task :sync_orders, [:arg1, :arg2] => :environment do |t, args|
    # Shop.activate_installed_shop_session
    # session = ShopifyAPI::Session.new(Shop.current_shopify_domain, Shop.current_shopify_token)
    # require 'openssl'
    # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    session = ShopifyAPI::Session.new({
      domain: ENV['SHOPIFY_DOMAIN'], 
      token: ENV['SHOPIFY_API_TOKEN'],
      api_version: ShopifyApp.configuration.api_version
    })
    # byebug
    ShopifyAPI::Base.activate_session(session)
    # puts ShopifyAPI::Order.all.sort_by(&:id).to_json#(include: [:variants, :options, :images, :image])
    # raise "return"
    new_item_count = 0
    updated_item_count = 0
    arg1 = args.try(:[], :arg1).presence
    arg2 = args.try(:[], :arg2).presence
    single_order_id = (0 != arg1.to_i || arg1.is_a?(Integer)) ? arg1 : nil
    ignore_errors = (0 != arg1.to_i || arg1.is_a?(Integer)) ? arg2 : arg1
    # :all w/o status returns only opened orders
    orders = single_order_id ? [ShopifyAPI::Order.find(single_order_id)] : ShopifyAPI::Order.find(:all, params: { status: "any" }).sort_by(&:id).reverse
    orders.each do |order|
      begin
        # stripped :origin_location and :destination_location from :tax_lines - it not always present and result in error
        order_as_params = order.as_json(include: {note_attributes: {}, tax_lines: {}, line_items: { include: [:tax_lines ]}, shipping_lines: {}, fulfillments: {}, refunds: {}, customer: { include: [:default_address]}}).deep_symbolize_keys
        # convert manually
        order_as_params[:client_details] = order_as_params[:client_details].try(:as_json) if order_as_params[:client_details].present?
        order_as_params[:payment_details] = order_as_params[:payment_details].try(:as_json) if order_as_params[:payment_details].present?
        order_as_params[:billing_address] = order_as_params[:billing_address].try(:as_json) if order_as_params[:billing_address].present?
        order_as_params[:shipping_address] = order_as_params[:shipping_address].try(:as_json) if order_as_params[:shipping_address].present?
        order_as_params[:discount_codes] = order_as_params[:discount_codes].try(:as_json) if order_as_params[:discount_codes].present?
        order_as_params.deep_symbolize_keys!

        # order_as_params[:variants].each do |v|
        #   v[:order_id] = order.id
        # end
        # order_as_params[:images].each do |i|
        #   i[:order_id] = order.id
        # end
        # byebug

        if Order.where(shopify_order_id: order.id).exists?
          Order.update_from_shopify_order!(order_as_params, false, true)
          updated_item_count += 1
        else
          Order.create_from_shopify_order!(order_as_params, true)
          new_item_count += 1
        end
      rescue StandardError => e
        puts order_as_params.present? ? order_as_params.to_json : order.as_json
        puts e.to_s + "\n" + e.backtrace.join("\n")
        if "true" != ignore_errors
          raise e
        end
        # try to ignore missing products and variants
        if e.is_a? ActiveRecord::RecordNotFound
          puts "Repeating with product_exists = false"
          order_as_params[:line_items].each do |li|
            li[:product_exists] = false
          end
          # repeat again
          begin
            if Order.where(shopify_order_id: order.id).exists?
              Order.update_from_shopify_order!(order_as_params, false, true)
              updated_item_count += 1
            else
              Order.create_from_shopify_order!(order_as_params, true)
              new_item_count += 1
            end
          rescue StandardError => e
            puts order_as_params.to_json
            puts e.to_s + "\n" + e.backtrace.join("\n")
          end #begin
        end #if
      end
    end
    puts "#{new_item_count} order(s) created, #{updated_item_count} order(s) updated"
  end
end
