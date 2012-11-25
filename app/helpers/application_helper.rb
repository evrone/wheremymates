module ApplicationHelper
  def need_popover
    current_user.part_of?(current_team) && current_team.users.one?
  end
end
