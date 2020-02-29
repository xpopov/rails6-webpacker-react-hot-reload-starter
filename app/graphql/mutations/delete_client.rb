class Mutations::DeleteClient < Mutations::BaseMutation
  description "Deletes Client"
  argument :id, ID, required: true
  field :deleted_id, ID, null: true
  field :errors, [Types::CustomError], null: true

  def resolve(params)
    client = Client.find(params[:id])
    raise GraphQL::ExecutionError, "Client not exists" unless client.present?
    client.destroy!
    { deleted_id: params[:id] }
  rescue ActiveRecord::RecordNotDestroyed => e
    message = e.record.errors.messages.map{ |k, v|
      "#{k.to_s}: #{v.join(", ")}"
    }.join("; ")
    raise GraphQL::ExecutionError, message
  end
end