module ApplicationHelper
  def need_popover
    current_team && current_team == current_user.team && current_user.team.users.one?
  end
end
