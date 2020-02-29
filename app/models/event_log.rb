class EventLog < ApplicationRecord
  self.inheritance_column = "type_not_used"
  acts_as_paranoid
  validates_presence_of :type, :internal_name, :group

  def self.create_event!(data, exception = nil)
    if exception.present?
      data[:exception_message] = exception.message
      data[:exception_line] = exception.backtrace.try(:first).to_s
      data[:exception_stack] = exception.backtrace.try(:join, "\n")
    end
    event = self.create!(data)
    if exception.present? && exception.class.to_s.in?(["InventoryLevelTooLowError", "InventoryLevelBelowRedLineWarning", "LocationAccessDeniedError", "LocationMissingError", "LocationPendingError", "SellerMissingError", "SellerNoAccessError", "ShopifyCustomerMissingError", "ShopifyOrderMissingError", "ShopifyProductMissingError", "ShopifyVariantMissingError", "SubscriptionMissingError"])
      event_data = JSON.parse(event.to_json)
      AdminNotificationService.new(:event, event_data).perform
    end
    if event.group == "gdpr_requests"
      request = JSON.parse(event.params)
      AdminNotificationService.new(:gdpr_request, request).perform
    end
  end

  def self.create_from_exception!(controller, action, params, method, path, remote_address, exception)
    data = {}
    data[:controller] = controller
    data[:action] = action
    data[:params] = params.to_json
    data[:method] = method
    data[:path] = path
    data[:remote_address] = remote_address
    data[:type] = "exception"
    data[:internal_name] = "default"
    data[:group] = "default"
    self.create_event!(data, exception)
  end

  # allow exception to be nil
  def self.create_from_method!(_class, method, message, exception, options = {})
    options[:optionskip_std_log] ||= false
    request = Thread.current[:request]
    data = {}
    data[:group] = "class_method"
    data[:controller] = Thread.current[:controller]
    data[:action] = Thread.current[:action]
    data[:params] = request.try(:params).to_json
    data[:method] = request.try(:method)
    data[:path] = request.try(:fullpath)
    data[:remote_address] = request.try(:ip)
    data[:type] = "exception"
    data[:internal_name] = _class + "." + method
    data[:message] = message
    if options[:optionskip_std_log].blank?
      AppLogger.errors_logger.error "#{_class}.#{method}: #{message}. #{exception}\n"
    end
    self.create_event!(data, exception)
  end

  def display_name
    id
  end
end
