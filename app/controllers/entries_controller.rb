class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def create
    team = Team.find_by_invitation_key!(params[:invitation_key])
    current_user.teams << team unless current_user.part_of? team
    redirect_to team
  end

  def destroy
    team = Team.find(params[:team_id])
    current_user.teams.delete team
    team.destroy if team.users.count <= 0
    redirect_to root_path
  end
end
