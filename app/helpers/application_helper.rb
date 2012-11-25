module ApplicationHelper
  def need_popover
    current_user.part_of?(current_team) && current_team.users.one?
  end

  def stylesheet_url(entry)
    ActionDispatch::Http::URL.url_for :path => stylesheet_path(entry), :host => Settings.host
  end

  def javascript_url(entry)
    ActionDispatch::Http::URL.url_for :path => javascript_path(entry), :host => Settings.host
  end
end
