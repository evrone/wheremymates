class TeamsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

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
end
