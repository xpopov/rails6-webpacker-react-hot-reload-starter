class CreateIntegrationsUpworkClients < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations_upwork_clients do |t|
      t.string :messages_room_id

      t.timestamps
    end
  end
end
