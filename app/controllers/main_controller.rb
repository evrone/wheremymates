class MainController < ApplicationController

  def index
    @teams = Team.where('users_count > 0').order('users_count DESC').limit(10)
  end

end
