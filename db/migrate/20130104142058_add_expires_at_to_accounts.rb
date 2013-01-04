class AddExpiresAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :expires_at, :datetime
    add_index :accounts, :expires_at
  end
end
