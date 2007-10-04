class UsersController < ApplicationController
  restrict_to :crud_users, :crud_companies_users, :except => [ :login, :logout, :reminder, :reminder_login, :signup ]
  
  acts_as_login_controller :allow_signup => true, :email_from => "admin@lotswholetime.com"

  redirect_after_login do
    { :controller => "dashboard" }
  end

  before_filter :find_groups, :find_companies, :only => [ :profile ]

  # GET /users
  # GET /users.xml
  def index
    @users = if current_user.has_privilege? :crud_users
      User.find( :all )
    else
      current_user.company.users.find(:all)
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @users.to_xml }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = if current_user.has_privilege? :crud_users
      User.find( params[:id] )
    else
      current_user.company.users.find(params[:id])
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = if current_user.has_privilege? :crud_users
      User.new
    else
      current_user.company.users.build
    end
    find_groups
    find_companies
  end

  # GET /users/1;edit
  def edit
    @user = 
    @user = if current_user.has_privilege? :crud_users
      User.find( params[:id] )
    else
      current_user.company.users.find(params[:id])
    end
    find_groups
    find_companies
  end

  # POST /users
  # POST /users.xml
  def create
    @user = if current_user.has_privilege? :crud_users
      User.new( params[:user] )
    else
      current_user.company.users.build( params[:user] )
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to user_url(@user) }
        format.xml { head :created, :location => user_url(@user) }
      else
        format.html do          
          find_groups
          find_companies
          render :action => "new"
        end
        format.xml { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = if current_user.has_privilege? :crud_users
      User.find( params[:id] )
    else
      current_user.company.users.find(params[:id])
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to user_url(@user) }
        format.xml { head :ok }
      else
        format.html do          
          find_groups
          find_companies
          render :action => "edit"
        end
        format.xml { render :xml => @user.errors.to_xml }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = if current_user.has_privilege? :crud_users
      User.find( params[:id] )
    else
      current_user.company.users.find(params[:id])
    end
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.xml { head :ok }
    end
  end
  
  private
  
  def find_groups
    @groups = Group.find( :all, :conditions => { :name => current_user.group.groups } ).map { |c| [ c.name, c.id ] }
    if @user and not @user.new_record? and @user != current_user
      @groups << [ @user.group.name, @user.group.id ]
    end
    @groups.uniq!
  end
  
  def find_companies
    @companies = if current_user.has_privilege? :crud_companies
      Company.find( :all ).map { |c| [ c.name, c.id ] }
    else
      [ [ current_user.company.name, current_user.company.id ] ]
    end
  end
end
