class RenameUsersCountToEntriesCountInTeams < ActiveRecord::Migration
  def change
    rename_column :teams, :users_count, :entries_count

    Team.reset_column_information
    Team.all.each do |team|
      Team.reset_counters(team.id, :entries)
    end
  end
end
