class CreateEventLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :event_logs do |t|
      t.string :type, null: false
      t.string :internal_name, null: false
      t.string :group, null: false
      t.string :controller
      t.string :action
      t.string :params
      t.string :method
      t.string :path
      t.string :status
      t.string :status_message
      t.string :exception_message
      t.string :exception_line
      t.string :exception_stack
      t.string :remote_address
      t.string :manual_status
      t.datetime :deleted_at
      t.string :message

      t.timestamps
    end
  end
end
