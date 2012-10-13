class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    # TODO Uncomment this and remove User.first when Facebook sign in complete
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    User.find_by_name('test1')
  end
  helper_method :current_user

end
