class CheckinsController < ApplicationController
  # TODO authentification

  def create
    current_user.checkins.create params[:checkin].merge(:checked_at => Time.now)
    head :created
  end

  def update
    @checkin = Checkin.find params[:id]
    @checkin.update_attribute :place, params[:place]
    head :ok
  end
end
