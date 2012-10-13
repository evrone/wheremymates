class TeamsController < ApplicationController
  #before_filter :require_team, only: [:show]
  before_filter :authenticate_user!, :only => [:create]

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

  private

  #def require_team
  #  unless current_team
  #    redirect_to root_url, alert: "Team required."
  #    false
  #  end
  #end

end
