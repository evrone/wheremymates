class TeamsController < ApplicationController
  before_filter :require_team, only: [:show]

  def show
  end

  private

  def require_team
    unless current_team
      redirect_to root_url, alert: "Team required."
      false
    end
  end

end
