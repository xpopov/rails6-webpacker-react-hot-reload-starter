class AddClientIdToIntegrationsUpworkClients < ActiveRecord::Migration[6.0]
  def change
    add_reference :integrations_upwork_clients, :client, foreign_key: true
  end
end
