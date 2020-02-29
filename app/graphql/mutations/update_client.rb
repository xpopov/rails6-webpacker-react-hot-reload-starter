class Mutations::UpdateClient < Mutations::BaseMutation
  description "update Client"
  argument :id, ID, required: true
  argument :first_name, String, required: true
  argument :last_name, String, required: true
  field :errors, [Types::CustomError], null: true
  field :client, Types::ClientType, null: false

  def resolve(params)
    client = Client.find(params[:id])
    raise GraphQL::ExecutionError, "Client not exists" unless client.present?

    client.update!(params.except(:id))
    { client: client }
  rescue ActiveRecord::RecordInvalid => e
    message = e.record.errors.messages.map{ |k, v|
      "#{k.to_s}: #{v.join(", ")}"
    }.join("; ")
    raise GraphQL::ExecutionError, message
  end
end