class InvitationsController < ApplicationController

  before_filter :find_project

  def create
    invitations = Invitation.create_for(@project, current_user, params[:email_addresses])
    invitations.each do |invitation|
      InvitationMailer.deliver_invitation invitation
    end
    
    redirect_to @project


    # @project.invitations.build_from_string( params[:invitation][:developers], :kind=>"developer", :inviter_id=>current_user.id ).each do |invitation|
    #   invitation.save!
    #   InvitationMailer.send "deliver_invite_#{invitation.kind}", invitation
    # end
    # @project.invitations.build_from_string( params[:invitation][:customers], :kind=>"customer", :inviter_id=>current_user.id ).each do |invitation|
    #   invitation.save!
    #   InvitationMailer.send "deliver_invite_#{invitation.kind}", invitation
    # end
    # flash[:notice] = "Your invitations have been sent!"
    # redirect_to project_path(@project)
    
  # rescue ActiveRecord::RecordNotSaved => ex
  #   flash[:error] = "Your invitations were unable to be sent!"
  #   redirect_to new_invitation_path( @project )
  end
  
  def new
    @invitation = Invitation.new
  end
  
  protected
  
  def find_project
    @project = Project.find( params[:project_id] )
  end
  
end
