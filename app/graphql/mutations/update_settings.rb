class Mutations::UpdateSettings < Mutations::BaseMutation
  description "Updates Settings"
  argument :companyName, String, required: true
  argument :identity, String, required: true
  argument :notification_emails, String, required: true
  field :errors, [Types::CustomError], null: true

  def resolve(params)
    # byebug
    Setting.update_payload(params)
  rescue ActiveRecord::RecordInvalid => e
    message = e.record.errors.messages.map{ |k, v|
      "#{k.to_s}: #{v.join(", ")}"
    }.join("; ")
    raise GraphQL::ExecutionError, message
  end
end