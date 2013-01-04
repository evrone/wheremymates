module UsersHelper
  def checkin_logo(checkin)
    if checkin.account
      image_tag "#{checkin.account.provider}_logo.png", :class => :logo
    else
      image_tag "wmm_logo.png", :class => :logo
    end
  end
end
