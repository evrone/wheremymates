class UsersController < ApplicationController
  # TODO authentification

  def update_geo
    current_user.update_attributes params[:user], :as => :geo_data
  end
end
