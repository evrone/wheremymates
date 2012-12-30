class CheckinsController < ApplicationController
  # TODO authentification

  def create
    current_user.checkins.create params[:checkin].merge(:checked_at => Time.now)
    head :created
  end
end
