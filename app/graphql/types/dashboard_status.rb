module Types
  class DashboardStatus < Types::BaseObject
    field :processing, Int, null: false
    field :failed, Int, null: false
    field :shipped, Int, null: false
    field :cancelled, Int, null: false
  end
end
