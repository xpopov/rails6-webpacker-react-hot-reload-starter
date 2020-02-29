class Client < ApplicationRecord
  has_one :upwork_integration, class_name: 'Integrations::Upwork::Client', dependent: :destroy

  validates_presence_of :first_name, :last_name

  after_create :create_dependencies

  def create_dependencies
    create_upwork_integration!
  end
end
