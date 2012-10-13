module ApplicationHelper

  def invite_link(text = nil)
    mail_to "enter_real_email_@_please", text,
      subject: 'Invitation to wheremymates.com',
      body: signin_url(invitation_key: current_user.team.invitation_key)
  end

end
