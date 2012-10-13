class UsersController < ApplicationController
  # TODO authentification

  def update_geo
    current_user.update_attributes params[:user].merge(:location_updated_at => Time.now), :as => :geo_data
  end
end
