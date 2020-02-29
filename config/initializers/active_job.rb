log_path = File.join(File.dirname(__FILE__), '..', '..', 'log', "activejob_#{Rails.env}.log")
ActiveJob::Base.logger = Logger.new(log_path)

class ActiveSupport::TimeWithZone
  include GlobalID::Identification

  def id
    (Time.zone.now.to_f * 1000).round
  end

  def self.find(milliseconds_since_epoch)
    Time.zone.at(milliseconds_since_epoch.to_f / 1000)
  end
end

class Time
  include GlobalID::Identification

  def id
    (Time.zone.now.to_f * 1000).round
  end

  def self.find(milliseconds_since_epoch)
    Time.zone.at(milliseconds_since_epoch.to_f / 1000)
  end
end


class Date
  include GlobalID::Identification

  alias_method :id, :to_s
  def self.find(date_string)
    Date.parse(date_string)
  end
end
