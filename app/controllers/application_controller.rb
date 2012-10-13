class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_team
    @current_team ||= Team.find_by_id(params[:team_id]) if params[:team_id]
    @current_team ||= current_user.team
    @current_team ||= Team.first
  end
  helper_method :current_team

  def request_geo?
    session[:geo_saved] ? false : session[:geo_saved] = true
  end
  helper_method :request_geo?
end
