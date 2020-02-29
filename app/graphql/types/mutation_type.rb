module Types
  class MutationType < Types::BaseObject
    field :update_settings, mutation: Mutations::UpdateSettings

    field :process_order, mutation: Mutations::ProcessOrder

    field :create_client, mutation: Mutations::CreateClient
    field :update_client, mutation: Mutations::UpdateClient
    field :delete_client, mutation: Mutations::DeleteClient
  end
end
