class MainController < ApplicationController

  def index
    @teams = Team.all(conditions: "users_count > 0", order: "users_count DESC")
  end

end
