class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :name, null: false, index: true, unique: true
      t.string :value, null: false

      t.timestamps
    end
  end
end
