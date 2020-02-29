require 'rails_helper'

describe "rake shopify:sync_orders", type: :task do
  _orders = []
  
  before(:all) {
    # create(:scenario)

    session = ShopifyAPI::Session.new({
      domain: Shop.current_shopify_domain, 
      token: Shop.current_shopify_token,
      api_version: ShopifyApp.configuration.api_version
    })
    ShopifyAPI::Base.activate_session(session)

    orders_json = '[{"id":118745890843,"email":"max.popov@gmail.com","closed_at":null,"created_at":"2017-10-09T12:17:37-04:00","updated_at":"2017-10-11T00:52:44-04:00","number":58,"note":null,"token":"fbbc22597b01159b7d33c66e4638bc7f","gateway":"bogus","test":true,"total_price":"130.00","subtotal_price":"100.00","total_weight":0,"total_tax":"30.00","taxes_included":false,"currency":"ILS","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"100.00","cart_token":"b41a42bc0a6cd314af43e43627106e30","buyer_accepts_marketing":false,"name":"#1058","referring_site":"","landing_site":"/admin/orders/108304597019","cancelled_at":null,"cancel_reason":null,"total_price_usd":"36.85","checkout_token":"326c4e8fbc844a83e236dd05d14570fd","reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2017-10-09T12:17:37-04:00","device_id":null,"phone":null,"customer_locale":"en","app_id":580111,"browser_ip":null,"landing_site_ref":null,"order_number":1058,"discount_codes":[],"note_attributes":[{"name":"seller_code","value":"3,8"},{"name":"location_code","value":"1"}],"payment_gateway_names":["bogus"],"processing_method":"direct","checkout_id":218608009243,"source_name":"web","fulfillment_status":null,"tax_lines":[{"title":"CA State Tax","price":"10.00","rate":0.1},{"title":"Butte County Tax","price":"10.00","rate":0.1},{"title":"Paradise Municipal Tax","price":"10.00","rate":0.1}],"tags":"","contact_email":"max.popov@gmail.com","order_status_url":"https://juvi-development.myshopify.com/18658437/orders/fbbc22597b01159b7d33c66e4638bc7f/authenticate?key=81a72fffedc7b7d00896a5c63bdfaf36","line_items":[{"id":220509044763,"variant_id":37835975691,"title":"Prod1","quantity":1,"price":"100.00","grams":0,"sku":"","variant_title":"v1","vendor":"juvi_development","fulfillment_service":"manual","product_id":9901652363,"requires_shipping":true,"taxable":true,"gift_card":false,"name":"Prod1 - v1","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[{"title":"CA State Tax","price":"10.00","rate":0.1},{"title":"Butte County Tax","price":"10.00","rate":0.1},{"title":"Paradise Municipal Tax","price":"10.00","rate":0.1}],"origin_location":{"id":45641039899,"country_code":"IL","province_code":"","name":"juvi_development","address1":"7 Weizel St","address2":"","city":"Tel Aviv","zip":"64241"},"destination_location":{"id":105787949083,"country_code":"US","province_code":"CA","name":"Max Popov","address1":"LA test","address2":"123","city":"Los Angeles","zip":"95967"}}],"shipping_lines":[{"id":87681368091,"title":"Std shipping","price":"0.00","code":"Std shipping","source":"shopify","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","tax_lines":[]}],"billing_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"shipping_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"fulfillments":[],"client_details":{"browser_ip":"37.195.242.85","accept_language":"ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4","user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36 OPR/48.0.2685.35","session_hash":"f31f66df566993b3ba1dd4f2ac343a8a","browser_width":1123,"browser_height":658},"refunds":[],"payment_details":{"credit_card_bin":"1","avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 1","credit_card_company":"Bogus"},"customer":{"id":60055191579,"email":"max.popov@gmail.com","accepts_marketing":false,"created_at":"2017-09-01T10:53:15-04:00","updated_at":"2017-10-10T10:54:38-04:00","first_name":"Max","last_name":"Popoff","orders_count":6,"state":"enabled","total_spent":"4640.00","last_order_id":108304597019,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1054","default_address":{"id":146931744795,"customer_id":60055191579,"first_name":"Max","last_name":"Popov","company":null,"address1":"LA test","address2":"123","city":"Los Angeles","province":"California","country":"United States","zip":"95967","phone":null,"name":"Max Popov","province_code":"CA","country_code":"US","country_name":"United States","default":true}}},{"id":121379651611,"email":"max.popov@gmail.com","closed_at":null,"created_at":"2017-10-10T10:52:30-04:00","updated_at":"2017-10-11T00:52:44-04:00","number":59,"note":null,"token":"3905fa9da1d8409cdef742c43b4cbab3","gateway":"bogus","test":true,"total_price":"225.00","subtotal_price":"150.00","total_weight":0,"total_tax":"75.00","taxes_included":false,"currency":"ILS","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"150.00","cart_token":"5cd5456ee0fb0a0a258fe5fe5fe3553c","buyer_accepts_marketing":false,"name":"#1059","referring_site":"","landing_site":"/admin/orders/108304597019","cancelled_at":null,"cancel_reason":null,"total_price_usd":"64.13","checkout_token":"cda5004fdf7c3969e87d6e8003d3f615","reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2017-10-10T10:52:30-04:00","device_id":null,"phone":null,"customer_locale":"en","app_id":580111,"browser_ip":null,"landing_site_ref":null,"order_number":1059,"discount_codes":[],"note_attributes":[{"name":"seller_code","value":"3,8"},{"name":"location_code","value":"1"}],"payment_gateway_names":["bogus"],"processing_method":"direct","checkout_id":218627538971,"source_name":"web","fulfillment_status":null,"tax_lines":[{"title":"State Tax","price":"75.00","rate":0.5}],"tags":"","contact_email":"max.popov@gmail.com","order_status_url":"https://juvi-development.myshopify.com/18658437/orders/3905fa9da1d8409cdef742c43b4cbab3/authenticate?key=11f368535349d07891ed6599f726e092","line_items":[{"id":224284049435,"variant_id":2479680389147,"title":"Product4","quantity":1,"price":"50.00","grams":0,"sku":"","variant_title":"white","vendor":"juvi_development","fulfillment_service":"manual","product_id":179145343003,"requires_shipping":true,"taxable":true,"gift_card":false,"name":"Product4 - white","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[{"title":"State Tax","price":"25.00","rate":0.5}],"origin_location":{"id":45641039899,"country_code":"IL","province_code":"","name":"juvi_development","address1":"7 Weizel St","address2":"","city":"Tel Aviv","zip":"64241"},"destination_location":{"id":105787949083,"country_code":"US","province_code":"CA","name":"Max Popov","address1":"LA test","address2":"123","city":"Los Angeles","zip":"95967"}},{"id":224284082203,"variant_id":37835975691,"title":"Prod1","quantity":1,"price":"100.00","grams":0,"sku":"","variant_title":"v1","vendor":"juvi_development","fulfillment_service":"manual","product_id":9901652363,"requires_shipping":true,"taxable":true,"gift_card":false,"name":"Prod1 - v1","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[{"title":"State Tax","price":"50.00","rate":0.5}],"origin_location":{"id":45641039899,"country_code":"IL","province_code":"","name":"juvi_development","address1":"7 Weizel St","address2":"","city":"Tel Aviv","zip":"64241"},"destination_location":{"id":105787949083,"country_code":"US","province_code":"CA","name":"Max Popov","address1":"LA test","address2":"123","city":"Los Angeles","zip":"95967"}}],"shipping_lines":[{"id":90003505179,"title":"Std shipping","price":"0.00","code":"Std shipping","source":"shopify","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","tax_lines":[]}],"billing_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"shipping_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"fulfillments":[],"client_details":{"browser_ip":"37.195.242.85","accept_language":"ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4","user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36 OPR/48.0.2685.35","session_hash":"f31f66df566993b3ba1dd4f2ac343a8a","browser_width":1123,"browser_height":658},"refunds":[],"payment_details":{"credit_card_bin":"1","avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 1","credit_card_company":"Bogus"},"customer":{"id":60055191579,"email":"max.popov@gmail.com","accepts_marketing":false,"created_at":"2017-09-01T10:53:15-04:00","updated_at":"2017-10-10T10:54:38-04:00","first_name":"Max","last_name":"Popoff","orders_count":6,"state":"enabled","total_spent":"4640.00","last_order_id":108304597019,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1054","default_address":{"id":146931744795,"customer_id":60055191579,"first_name":"Max","last_name":"Popov","company":null,"address1":"LA test","address2":"123","city":"Los Angeles","province":"California","country":"United States","zip":"95967","phone":null,"name":"Max Popov","province_code":"CA","country_code":"US","country_name":"United States","default":true}}},{"id":121382633499,"email":"max.popov@gmail.com","closed_at":null,"created_at":"2017-10-10T10:54:38-04:00","updated_at":"2017-10-11T00:52:44-04:00","number":60,"note":null,"token":"82f9412eb32eb9df987a1438175460f6","gateway":"bogus","test":true,"total_price":"37.50","subtotal_price":"25.00","total_weight":0,"total_tax":"12.50","taxes_included":false,"currency":"ILS","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"25.00","cart_token":"d47689ded0a3bde8b4ee87e71029b84e","buyer_accepts_marketing":false,"name":"#1060","referring_site":"","landing_site":"/admin/orders/108304597019","cancelled_at":null,"cancel_reason":null,"total_price_usd":"10.69","checkout_token":"385c991412203d48ee752ab5848967d0","reference":null,"user_id":null,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2017-10-10T10:54:38-04:00","device_id":null,"phone":null,"customer_locale":"en","app_id":580111,"browser_ip":null,"landing_site_ref":null,"order_number":1060,"discount_codes":[],"note_attributes":[{"name":"seller_code","value":"3,8"},{"name":"location_code","value":"1"}],"payment_gateway_names":["bogus"],"processing_method":"direct","checkout_id":221810819099,"source_name":"web","fulfillment_status":null,"tax_lines":[{"title":"State Tax","price":"12.50","rate":0.5}],"tags":"","contact_email":"max.popov@gmail.com","order_status_url":"https://juvi-development.myshopify.com/18658437/orders/82f9412eb32eb9df987a1438175460f6/authenticate?key=781ed5674affdc831f6939da6a274536","line_items":[{"id":224289914907,"variant_id":2479391342619,"title":"Product3","quantity":1,"price":"25.00","grams":0,"sku":"","variant_title":"1","vendor":"juvi_development","fulfillment_service":"manual","product_id":179124469787,"requires_shipping":true,"taxable":true,"gift_card":false,"name":"Product3 - 1","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[{"title":"State Tax","price":"12.50","rate":0.5}],"origin_location":{"id":45641039899,"country_code":"IL","province_code":"","name":"juvi_development","address1":"7 Weizel St","address2":"","city":"Tel Aviv","zip":"64241"},"destination_location":{"id":105787949083,"country_code":"US","province_code":"CA","name":"Max Popov","address1":"LA test","address2":"123","city":"Los Angeles","zip":"95967"}}],"shipping_lines":[{"id":90005864475,"title":"Std shipping","price":"0.00","code":"Std shipping","source":"shopify","phone":null,"requested_fulfillment_service_id":null,"delivery_category":null,"carrier_identifier":null,"discounted_price":"0.00","tax_lines":[]}],"billing_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"shipping_address":{"first_name":"Max","address1":"LA test","phone":null,"city":"Los Angeles","zip":"95967","province":"California","country":"United States","last_name":"Popov","address2":"123","company":null,"latitude":null,"longitude":null,"name":"Max Popov","country_code":"US","province_code":"CA"},"fulfillments":[],"client_details":{"browser_ip":"37.195.242.85","accept_language":"ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4","user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36 OPR/48.0.2685.35","session_hash":"f31f66df566993b3ba1dd4f2ac343a8a","browser_width":1123,"browser_height":658},"refunds":[],"payment_details":{"credit_card_bin":"1","avs_result_code":null,"cvv_result_code":null,"credit_card_number":"•••• •••• •••• 1","credit_card_company":"Bogus"},"customer":{"id":60055191579,"email":"max.popov@gmail.com","accepts_marketing":false,"created_at":"2017-09-01T10:53:15-04:00","updated_at":"2017-10-10T10:54:38-04:00","first_name":"Max","last_name":"Popoff","orders_count":6,"state":"enabled","total_spent":"4640.00","last_order_id":108304597019,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"phone":null,"tags":"","last_order_name":"#1054","default_address":{"id":146931744795,"customer_id":60055191579,"first_name":"Max","last_name":"Popov","company":null,"address1":"LA test","address2":"123","city":"Los Angeles","province":"California","country":"United States","zip":"95967","phone":null,"name":"Max Popov","province_code":"CA","country_code":"US","country_name":"United States","default":true}}}]'

    # area = create(:area, company: create(:company))
    # location = create(:location, area: area)

    _orders = JSON.parse(orders_json).map do |order_json|
      order = ShopifyAPI::Order.new(order_json)
      # unless User.where(shopify_customer_id: order.customer.id).exists?
      #   customer_data = build(:shopify_customer)
      #   customer_data.id = order.customer.id
      #   User.create_from_shopify_customer!(customer_data)
      # end
      # order.line_items.each do |li|
      #   unless Product.where(shopify_product_id: li.product_id).exists?
      #     product = Product.create_from_shopify_product!(build_stubbed(:shopify_product))
      #     product.shopify_product_id = li.product_id
      #     product.save!
      #   end
      #   unless ProductVariant.where(shopify_variant_id: li.variant_id).exists?
      #     variant_data = build_stubbed(:shopify_product_variant)
      #     variant_data[:product_id] = product.id
      #     variant_data[:id] = li.variant_id
      #     new_variant = ProductVariant.new ProductVariant.build_attributes_from_shopify_variant(variant_data)
      #     product.variants.push new_variant
      #     Inventory.create!(product_variant_id: new_variant.id, location_id: location.id, quantity: li.quantity)
      #   end
      # end
      order
    end
  }

  before(:each) {
    allow(ShopifyAPI::Order).to receive(:find).and_return(_orders)
  }

  after(:all) {
    DatabaseCleaner.clean_with(:truncation)
  }

  let!(:orders) {
    _orders
  }

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "creates missing orders" do
    # run task
    expect {
      task.execute
    }.to change(Order, :count).from(0).to(orders.count)

    orders.sort_by(&:id).each do |order|
      db_order = Order.find_by!(shopify_order_id: order.id)

      expect(db_order.shopify_order_id).to   eq order.id.to_s
    end
  end

  it "updates existing orders" do
    # create all the orders with fake data and real id
    orders.sort_by(&:id).each do |order|
      order_data = create(:shopify_order)
      order_data.id = order.id
      order_data.customer.id = order.customer.id
      order_data.line_items = order.line_items.as_json(include: [:tax_lines, :destination_location]).map(&:deep_symbolize_keys)
      # order_data.tax_lines = order.tax_lines.as_json.map(&:deep_symbolize_keys)

      # unless User.where(shopify_customer_id: order.customer.id).exists?
      #   customer_data = build(:shopify_customer)
      #   customer_data.id = order.customer.id
      #   User.create_from_shopify_customer!(customer_data)
      # end

      order.line_items.each do |li|
        # unless Product.where(shopify_product_id: li.product_id).exists?
        #   product = Product.create_from_shopify_product!(build_stubbed(:shopify_product))
        #   product.shopify_product_id = li.product_id
        #   product.save!
        # end
        # unless ProductVariant.where(shopify_variant_id: li.variant_id).exists?
        #   variant_data = build_stubbed(:shopify_product_variant)
        #   variant_data[:product_id] = product.id
        #   variant_data[:id] = li.variant_id
        #   new_variant = ProductVariant.new ProductVariant.build_attributes_from_shopify_variant(variant_data)
        #   product.variants.push new_variant
        #   Inventory.create!(product_variant_id: new_variant.id, location_id: location.id, quantity: li.quantity)
        # end
      end

      Order.create_from_shopify_order!(order_data)
   end

    # run task
    expect {
      task.execute
    }.not_to change(Order, :count)

    orders.sort_by(&:id).each do |order|
      db_order = Order.find_by!(shopify_order_id: order.id)
      
      expect(db_order.shopify_order_id).to   eq order.id.to_s
    end
  end
end