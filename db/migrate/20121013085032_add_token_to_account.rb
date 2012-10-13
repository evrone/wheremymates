class AddTokenToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :token, :string, null: false
  end
end
