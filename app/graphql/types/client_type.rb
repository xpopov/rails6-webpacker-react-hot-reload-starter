module Types
  class ClientType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :upwork_room_id, String, null: true

    def upwork_room_id
      object.upwork_integration.try(:messages_room_id)
    end
  end
end
