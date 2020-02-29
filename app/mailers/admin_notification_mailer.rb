class AdminNotificationMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  
  def send_event_to_admins(event, email)
    @server = ENV['SHOPIFY_APP_URL']
    @subject = "Event on #{@server}"
    @event = OpenStruct.new(event)
    @email = email
    mail(to: @email, subject: @subject)
  end

  def send_notice_to_admins(notice, email)
    @server = ENV['SHOPIFY_APP_URL']
    @subject = "Notice for #{@server}"
    @notice = OpenStruct.new(notice)
    @email = email
    mail(to: @email, subject: @subject)
  end

  def send_gdpr_request_to_admins(request, email)
    @server = ENV['SHOPIFY_APP_URL']
    @subject = "New GDPR Request for #{@server}"
    @request = OpenStruct.new(request)
    @email = email
    mail(to: @email, subject: @subject)
  end
end
