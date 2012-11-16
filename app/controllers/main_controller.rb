class MainController < ApplicationController

  def index
    @teams = Team.where('entries_count > 0').order('entries_count DESC')
  end

end
