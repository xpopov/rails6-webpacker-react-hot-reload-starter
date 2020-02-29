class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from(StandardError) do |exception|
    logger.error "Exception in ActiveJob: message: #{exception.message.strip}"
    EventLog.create_event!({
      type: "exception",
      internal_name: self.class.to_s,
      group: "jobs",
      controller: self.class.to_s,
      action: 'perform',
      params: self.arguments,
      exception_message: exception.message,
      exception_line: exception.backtrace.first.to_s,
      exception_stack: exception.backtrace.join("\n")
    })
    # EventLog.create_from_exception! "active_job", self.class.to_s, {}, request.method, request.fullpath, request.ip, exception
    raise exception
  end

  # period when waiting for other related entities, sec
  def max_delay
    if Rails.configuration.try(:enable_long_tests)
      30
    else
      Rails.env.test? ? 5 : 120
    end
  end

  # def set_log_tags
  #   logger.tagged("juvinesse_#{Rails.env}") do
  #     yield
  #   end
  # end  
end
