class Mutations::CreateClient < Mutations::BaseMutation
  description "Create Client"
  argument :first_name, String, required: true
  argument :last_name, String, required: true
  field :client, Types::ClientType, null: false

  def resolve(params)
    # byebug
    { client: Client.create!(params) }
  rescue ActiveRecord::RecordInvalid => e
    message = e.record.errors.messages.map{ |k, v|
      "#{k.to_s}: #{v.join(", ")}"
    }.join("; ")
    raise GraphQL::ExecutionError, message
  end
end