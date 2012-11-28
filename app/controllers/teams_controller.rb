class TeamsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :create]

  respond_to :html, :json, :js

  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    set_current_team(@team)
  end

  def embed
    @team = Team.find(params[:id])
  end

  def create
    team = Team.create!(params[:team])
    current_user.teams << team

    respond_with team
  end
end
