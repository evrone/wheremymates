class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.belongs_to :user
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :accounts, :user_id
    add_index :accounts, :provider
  end
end
