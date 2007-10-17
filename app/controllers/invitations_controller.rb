class InvitationsController < ApplicationController

  before_filter :find_project

  def create
    invitations = Invitation.create_for(@project, current_user, params[:email_addresses], params[:email_body])
    invitations.each do |invitation|
      invitation.accept_invitation_url = login_url(:code=>invitation.code)
      InvitationMailer.deliver_invitation invitation
    end
    
    redirect_to @project
  end
  
  def new
    @invitation = Invitation.new
  end
  
  protected
  
  def find_project
    @project = Project.find( params[:project_id] )
  end
  
end
