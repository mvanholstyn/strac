require 'singleton'

class InvitationManager
  include Singleton

  def self.create_for(project, inviter, recipients, message)
    recipients.split(/\s*,\s*/).map do |recipient|
      Invitation.create!(:project => project, :inviter => inviter, :recipient => recipient, 
                         :code => UniqueCodeGenerator.generate(recipient),
                         :message => message)
    end
  end

  
  def self.accept_pending_invitations(session, user)
    instance.accept_pending_invitations(session, user)
  end
  
  def self.store_pending_invitation_acceptance(session, code)
    instance.store_pending_invitation_acceptance(session, code)
  end
  
  def accept_pending_invitations(session, user)
    pending_invite_code = session[:pending_invite_code]
    if pending_invite_code
      session[:pending_invite_code] = nil
      invitation = Invitation.find_by_code(pending_invite_code)
      project = Project.find(invitation.project_id)
      user.projects << project
      project.name
    end
  end
  
  def store_pending_invitation_acceptance(session, code)
    session[:pending_invite_code] = code
  end
end