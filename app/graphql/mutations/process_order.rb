class Mutations::ProcessOrder < Mutations::BaseMutation
  description "Process Order"
  argument :order_id, ID, required: true
  field :status, String, null: false
  field :errors, [Types::CustomError], null: true

  def resolve(params)
    order = Order.find(params[:order_id])
    raise GraphQL::ExecutionError, "Order not exists" unless order.present?
    # Do some work
    { status: "OK" }
  rescue Exception => e
    message = e.message
    raise GraphQL::ExecutionError, message
  end
end
