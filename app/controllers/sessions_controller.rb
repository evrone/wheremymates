class SessionsController < ApplicationController
  def create
    # raise env['omniauth.auth'].to_yaml
    auth = env['omniauth.auth']
    if auth[:provider] == 'facebook'
      user = User.from_omniauth(auth)

      user.team = Team.first  # TODO: fix stub
      user.save!

      session[:user_id] = user.id
      redirect_to root_url, notice: "Signed in."
    else
      account = Account.from_omniauth(current_user, auth)
      redirect_to root_url, notice: "#{auth[:provider]} account added."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out."
  end
end
