class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :invitation_key, null: false

      t.timestamps
    end
    add_index :teams, :invitation_key, :unique => true
  end
end
