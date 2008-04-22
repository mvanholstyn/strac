class InvitationsController < ApplicationController
  before_filter :find_project

  def create
    email_addresses = params[:email_addresses].split(/\s*,\s*/)
    invitations = email_addresses.map do |recipient|
      Invitation.create!(:project => @project, :inviter => current_user, :recipient => recipient, 
                         :code => UniqueCodeGenerator.generate(recipient),
                         :message => params[:email_body])
    end
    invitations.each do |invitation|
      invitation.accept_invitation_url = login_url(:code => invitation.code)
      InvitationMailer.deliver_invitation invitation
    end
    
    redirect_to @project
  end
  
  def new
    @invitation = Invitation.new
  end
  
private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
