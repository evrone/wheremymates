class TeamsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :join, :leave]

  respond_to :html, :json

  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    set_current_team(@team)
  end

  def create
    team = Team.create!(params[:team])
    current_user.teams << team

    respond_with team
  end

  def join
    team = Team.find_by_invitation_key!(params[:invitation_key])
    current_user.teams += team
    redirect_to team
  end

  def leave
    team = Team.find(params[:id])
    current_user.teams -= team
    team.destroy if team.users.count <= 0

    redirect_to root_path
  end
end
