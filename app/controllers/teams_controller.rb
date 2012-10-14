class TeamsController < ApplicationController
  before_filter :require_user_in_team, only: [:my, :destroy]
  before_filter :authenticate_user!, :only => [:create, :my, :join, :destroy]

  respond_to :html, :json

  def new
    if current_user.team
      redirect_to current_user.team, notice: "Already in a team."
    else
      @team = Team.new
    end
  end

  def show
    @team = Team.find(params[:id])
    set_current_team(@team)
  end

  def create
    unless current_user.team
      team = Team.create!(params[:team])
      current_user.update_attribute(:team, team)
    end

    respond_with(current_user.team)
  end

  def my
    redirect_to current_user.team
  end

  def join
    team = Team.find_by_invitation_key!(params[:invitation_key])
    current_user.update_attribute(:team, team)
    redirect_to team
  end

  def leave
    current_user.update_attribute(:team, nil)
    redirect_to root_path
  end

  #def destroy
  #  current_user.team.destroy
  #  redirect_to root_path
  #end

  private

  def require_user_in_team
    unless current_user.team
      redirect_to root_url, alert: "Team required."
      false
    end
  end

end
