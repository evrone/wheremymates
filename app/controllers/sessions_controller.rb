class SessionsController < ApplicationController
  def new
    redirect_to "/auth/facebook"
  end

  def create
    auth = env['omniauth.auth']
    if current_user
      Account.from_omniauth(current_user, auth)
      flash.notice = "#{auth[:provider]} account added."
    else
      user = User.from_omniauth(auth)

      session[:user_id] = user.id
      flash.notice = "Signed in."
    end

    redirect_to after_sign_in_path
    reset_after_sign_in_path!
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out."
  end

end
