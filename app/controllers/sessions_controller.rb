class SessionsController < ApplicationController
  def new
    session[:invitation_key] = params[:invitation_key]

    redirect_to "/auth/facebook"
  end

  def create
    auth = env['omniauth.auth']
    if auth[:provider] == 'facebook'
      user = User.from_omniauth(auth)

      if session[:invitation_key]
        team = Team.find_by_invitation_key(session[:invitation_key])
        if team
          user.update_attribute(:team, team)
        end
      end

      # TODO: fix stub
      unless user.team
        user.update_attribute(:team, Team.order(:id).first)
      end

      session[:user_id] = user.id
      redirect_url = user.team ? user.team : root_url
      redirect_to redirect_url, notice: "Signed in."
    else
      account = Account.from_omniauth(current_user, auth)
      redirect_to root_url, notice: "#{auth[:provider]} account added."
    end
  end

  def destroy
    session[:user_id] = nil
    session[:geo_saved] = nil
    redirect_to root_url, notice: "Signed out."
  end
end
