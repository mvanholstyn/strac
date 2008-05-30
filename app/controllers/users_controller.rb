class UsersController < ApplicationController
  acts_as_login_controller :allow_signup => true, :email_from => "admin@lotswholetime.com",
                           :signup_email_subject => "Welcome to strac"
  restrict_to :user

  after_filter :process_invitation, :only => :login

  redirect_after_login do
    dashboard_path
  end

  after_successful_signup do
    set_current_user @user
    accepted_project_name = InvitationManager.accept_pending_invitations(session, current_user)
    if accepted_project_name
      flash[:notice] = "You have been added to project: #{accepted_project_name}"
    end
  end
  
  redirect_after_signup do
    dashboard_path
  end
  
  before_filter :assign_group, :only => [:signup]
  before_filter :find_groups, :only => [:profile]
  
private

  def process_invitation
    if request.get?
      InvitationManager.store_pending_invitation_acceptance(session, params[:code])
    elsif request.post? && current_user
      accepted_project_name = InvitationManager.accept_pending_invitations(session, current_user)
      if accepted_project_name
        flash[:notice] = "You have been added to project: #{accepted_project_name}"
      end
    end
  end

  def assign_group
    if params[:user]
      params[:user][:group_id] = Group.find_by_name("Developer").id
      params[:user][:active] = true
    end
  end
  
  def find_groups
    @groups = Group.find(:all, :conditions => { :name => current_user.group.groups }).map { |c| [c.name, c.id] }
    if @user and not @user.new_record? and @user != current_user
      @groups << [@user.group.name, @user.group.id]
    end
    @groups.uniq!
  end
end
