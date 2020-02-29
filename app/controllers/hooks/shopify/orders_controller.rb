class Hooks::Shopify::OrdersController < Hooks::Shopify::WebhookController

  def create
    order = build_order
    Shopify::OrderCreateJob.perform_later({shop_domain: shop_domain, order: order})
    # print ({shop_domain: shop_domain, order: order}).inspect
    head :ok
  end

  def updated
    order = build_order
    update_job_low_priority.perform_later({shop_domain: shop_domain, order: order})
    # print ({shop_domain: shop_domain, order: order}).inspect
    head :ok
  end

  def delete
    order = delete_params.to_h.deep_symbolize_keys
    Shopify::OrderDeleteJob.perform_later({shop_domain: shop_domain, order: order})
    head :ok
  end

  def cancelled
    order = build_order
    update_job_low_priority.perform_later({shop_domain: shop_domain, order: order})
    head :ok
  end

  def fulfilled
    order = build_order
    update_job_low_priority.perform_later({shop_domain: shop_domain, order: order})
    head :ok
  end

  def partially_fulfilled
    order = build_order
    update_job_low_priority.perform_later({shop_domain: shop_domain, order: order})
    head :ok
  end

  def paid
    order = build_order
    update_job_low_priority.perform_later({shop_domain: shop_domain, order: order, action: "paid"})
    head :ok
  end


  private

  def update_job_low_priority
    Rails.env.test? ? Shopify::OrderUpdateJob : Shopify::OrderUpdateJob.set(wait: 10.second)
  end

  def build_order
    order = order_params.to_h.deep_symbolize_keys
    order[:discount_codes] = discount_codes_param
    order[:note_attributes] = note_attributes_params
    order[:customer] = customer_params.to_h.deep_symbolize_keys
    order[:billing_address] = billing_address_params.to_h.deep_symbolize_keys
    order[:shipping_address] = shipping_address_params.to_h.deep_symbolize_keys
    order[:line_items] = line_items_params
    # order[:tax_lines] = tax_lines_params
    recursive_delete_gids(order)
  end

  def delete_params
    webhook_params.require(:id)
    { id: webhook_params[:id] }
  end

  def discount_codes_param
    if webhook_params[:discount_codes].present?
      webhook_params.require(:discount_codes).each do |param|
        param.require(:code)
        param.require(:amount)
        param.require(:type)
      end
      webhook_params[:discount_codes].map{ |na| na.to_h.deep_symbolize_keys }
    else
      []
    end
  end

  def note_attributes_params
    if webhook_params[:note_attributes].present?
      webhook_params.require(:note_attributes).each do |param|
        param.require(:name)
        # param.require(:value)
      end
    end
    webhook_params[:note_attributes].map{ |na| na.to_h.deep_symbolize_keys }
  end

  def customer_params
    webhook_params.require(:customer).require(:id)
    webhook_params.require(:customer).require(:email)
    webhook_params.require(:customer).permit(:first_name)
    webhook_params.require(:customer).permit(:last_name)
    webhook_params[:customer]
  end

  @@address_fields_required = [
    # :first_name,
    # :last_name,
    :country,
    :name,
    :country_code
  ]

  def billing_address_params
    webhook_params.permit(:billing_address)
    if webhook_params[:billing_address].present?
      @@address_fields_required.each do |field|
        webhook_params.require(:billing_address).require(field)
      end
      webhook_params[:billing_address]
    else
      {}
    end
  end

  def shipping_address_params
    webhook_params.permit(:shipping_address)
    if webhook_params[:shipping_address].present?
      @@address_fields_required.each do |field|
        webhook_params.require(:shipping_address).require(field)
      end
      webhook_params[:shipping_address]
    else
      {}
    end
end
  
  def tax_lines_params
    if webhook_params[:tax_lines].present?
      webhook_params.require(:tax_lines).each do |param|
        param.require(:title)
        param.require(:price)
        param.require(:rate)
      end
      webhook_params[:tax_lines].map{ |tl| tl.to_h.deep_symbolize_keys }
    else
      []
    end
  end

  def line_items_params
    if webhook_params[:line_items].present?
      webhook_params.require(:line_items).each do |param|
        param.require(:id)
        param.require(:variant_id)
        param.require(:title)
        param.require(:quantity)
        param.require(:price)
        param.permit(:grams)
        param.permit(:sku)
        param.permit(:variant_title)
        param.require(:vendor)
        param.require(:fulfillment_service)
        param.require(:product_id) if param[:product_exists].present?
        param.permit(:taxable)
        param.require(:name)
        param.permit(:fulfillable_quantity)
        param.require(:total_discount)
        param.permit(:fulfillment_status)
      end
    end
    webhook_params[:line_items].map{ |i| i.to_h.deep_symbolize_keys }
  end

  def order_params
    webhook_params.require(:order).require(:id)
    webhook_params.require(:order).permit(:cancel_reason)
    webhook_params.require(:order).permit(:cart_token)
    webhook_params.require(:order).require(:currency)
    webhook_params.require(:order).permit(:user_id) #user_id is only for locations
    webhook_params.require(:order).require(:email)
    webhook_params.require(:order).require(:financial_status)
    webhook_params.require(:order).permit(:fulfillment_status)
    webhook_params.require(:order).require(:name)
    webhook_params.require(:order).permit(:note)
    webhook_params.require(:order).require(:number)
    webhook_params.require(:order).require(:order_number)
    webhook_params.require(:order).permit(:phone)
    webhook_params.require(:order).require(:subtotal_price)
    webhook_params.require(:order).permit(:taxes_included)
    webhook_params.require(:order).require(:total_line_items_price)
    webhook_params.require(:order).require(:total_price)
    webhook_params.require(:order).permit(:total_tax)
    webhook_params.require(:order).permit(:cancelled_at)
    webhook_params.require(:order).permit(:closed_at)
    webhook_params.require(:order).permit(:processed_at)
    webhook_params.require(:order).require(:created_at)
    webhook_params.require(:order).permit(:updated_at)
    webhook_params.permit(:processing_method)
    result = webhook_params[:order]
    result[:processing_method] = webhook_params[:processing_method]
    result
  end

end
