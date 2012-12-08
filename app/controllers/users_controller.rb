class UsersController < ApplicationController
  # TODO authentification

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end

  def update_geo
    current_user.update_attributes params[:user].merge(:location_updated_at => Time.now), :as => :geo_data
  end
end
