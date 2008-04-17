class InvitationMailer < ActionMailer::Base

  def invitation(invitation)
    recipients invitation.recipient
    from invitation.inviter.email_address
    subject "You've been invited to #{invitation.project.name}!"
    body :invitation => invitation
  end
  
end
