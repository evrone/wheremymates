class CreateEntries < ActiveRecord::Migration
  class User < ActiveRecord::Base
    belongs_to :team
  end

  class Entry < ActiveRecord::Base
    belongs_to :user
    belongs_to :team
  end

  def up
    create_table :entries do |t|
      t.references :team, :user
      t.timestamps
    end
    add_index :entries, :team_id
    add_index :entries, :user_id

    User.all.each do |user|
      if user.team_id
        Entry.create do |e|
          e.user_id = user.id
          e.team_id = user.team_id
        end
      end
    end
  end

  def down
    drop_table :entries
  end
end
