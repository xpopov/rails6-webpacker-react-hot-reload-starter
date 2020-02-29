class Types::CustomError < Types::BaseObject
  description "A user-readable error"

  field :path, String, null: true,
    description: "Which input value this error came from"
  field :message, String, null: false,
    description: "A description of the error"
end