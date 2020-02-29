module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ status: false, message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ status: false, message: e.message }, :unprocessable_entity)
    end

    rescue_from StandardError do |e|
      EventLog.create_from_exception! params[:controller], params[:action], request.params, request.method, request.fullpath, request.ip, e
      if Rails.env.development?
        raise e
        return
      end
      json_response({ status: false, message: e.message }, :unprocessable_entity)
    end
  end
end
