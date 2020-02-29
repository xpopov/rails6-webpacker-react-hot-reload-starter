module Types
  class MutationType < Types::BaseObject
    field :update_settings, mutation: Mutations::UpdateSettings

    field :process_order, mutation: Mutations::ProcessOrder
  end
end
