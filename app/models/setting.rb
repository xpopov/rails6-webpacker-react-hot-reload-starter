class Setting < ApplicationRecord
  validates_presence_of :name, :value
  validates :name, uniqueness: true

  def self.update_payload(settings)
    settings.each do |value|
      # byebug
      s = Setting.find_or_initialize_by(name: value[0])
      s.update!(value: value[1])
    end
  end

  def self.get_payload
    # byebug
    Setting.all.map{ |s| { s.name => s.value } }.reduce(:merge).try(:with_indifferent_access) || {  }
  end
end
