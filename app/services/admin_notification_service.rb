class AdminNotificationService
  attr_reader :type
  attr_reader :data

  def initialize(type, data)
    @type = type
    @data = data
  end

  def perform
    # get emails from settings
    emails = %w{max.popov@gmail.com}
    emails.each do |email|
      if :event == type
        AdminNotificationMailer.send_event_to_admins(data, email).deliver_later
      elsif :notice == type
        AdminNotificationMailer.send_notice_to_admins(data, email).deliver_later
      elsif :gdpr_request == type
        AdminNotificationMailer.send_gdpr_request_to_admins(data, email).deliver_later
      end
    end
  end
end