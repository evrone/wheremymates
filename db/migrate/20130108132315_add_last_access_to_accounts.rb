class AddLastAccessToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_access, :string
  end
end
