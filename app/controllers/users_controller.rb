class UsersController < ApplicationController
  acts_as_login_controller :allow_signup => true, :email_from => "admin@lotswholetime.com"

  redirect_after_login do
    dashboard_path
  end
  
  before_filter :assign_group, :only => [:signup]
  before_filter :find_groups, :only => [:profile]
  
private

  def assign_group
    if params[:user]
      params[:user][:group_id] = Group.find_by_name("User").id
      params[:user][:active] = true
    end
  end
  
  def find_groups
    @groups = Group.find( :all, :conditions => { :name => current_user.group.groups } ).map { |c| [ c.name, c.id ] }
    if @user and not @user.new_record? and @user != current_user
      @groups << [ @user.group.name, @user.group.id ]
    end
    @groups.uniq!
  end
end
