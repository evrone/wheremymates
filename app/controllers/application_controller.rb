class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_team
    @current_team ||= Team.find_by_current_team_id(session[:current_team_id]) if session[:current_team_id]
  end
  helper_method :current_team

  def set_current_team(team)
    session[:current_team_id] = team.id
  end
end
