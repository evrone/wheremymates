class AddUsersCountToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :users_count, :integer, :null => false, :default => 0
    Team.reset_column_information
    Team.find_each do |team|
      Team.reset_counters(team.id, :users)
    end
  end
end
