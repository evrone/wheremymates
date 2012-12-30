class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :user, :account
      t.string :uid, :place, :desc, :link
      t.float :latitude, :longitude, :null => false
      t.datetime :checked_at
      t.timestamps
    end

    add_index :checkins, :account_id
    add_index :checkins, :user_id
    add_index :checkins, :uid
    add_index :checkins, :checked_at
  end
end
