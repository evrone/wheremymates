class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate_user!
    return true if current_user

    set_after_sign_in_path(request.url)
    redirect_to root_path, :notice => "Please log in"
  end

  def after_sign_in_path
    if session[:return_path]
      session[:return_path]
    else
      current_user.teams.exists? ? root_path : new_team_path
    end
  end

  def set_after_sign_in_path(url)
    session[:return_path] = url
  end

  def reset_after_sign_in_path!
    session.delete(:return_path)
  end

  def current_team
    @current_team
  end
  helper_method :current_team

  def set_current_team(team)
    @current_team = team
  end

  def request_geo?
    session[:geo_saved] ? false : session[:geo_saved] = true
  end
  helper_method :request_geo?
end
