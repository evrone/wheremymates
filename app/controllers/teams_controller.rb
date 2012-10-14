class TeamsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :join]

  def show
    @team = Team.find(params[:id])
    set_current_team(@team)
  end

  def create
    prev_team = current_user.team

    if params[:team][:name].present?
      team = Team.find_or_create_by_name(params[:team][:name])
      current_user.update_attribute(:team, team)
    else
      current_user.update_attribute(:team, nil)
    end

    prev_team.destroy if prev_team && prev_team.users.count <= 0

    redirect_to root_path
  end

  def join
    team = Team.find_by_invitation_key!(params[:invitation_key])
    current_user.update_attribute(:team, team)
    redirect_to team
  end
end
