module Types
  class Settings < Types::BaseObject
    field :companyName, String, null: true
    field :identity, String, null: true
    field :notification_emails, String, null: true
  end
end
