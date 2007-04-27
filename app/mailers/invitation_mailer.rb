class InvitationMailer < ActionMailer::Base
  
  def invite_developer( invitation )
    recipients invitation.recipient
    from "#{invitation.inviter.email_address} <#{invitation.inviter.full_name}>"
    subject "You've been invited as a developer to '#{invitation.project.name}'!"
    body :invitation => invitation
  end
  
  def invite_customer( invitation )
    recipients invitation.recipient
    from "#{invitation.inviter.email_address} <#{invitation.inviter.full_name}>"
    subject "You've been invited as a customer to '#{invitation.project.name}'!"
    body :invitation => invitation
  end
  
end
