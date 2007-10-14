class ProjectsController < ApplicationController
  restrict_to :user
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = ProjectPermission.find_all_projects_for_user( current_user )
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @projects.to_xml }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @project.to_xml }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1;edit
  def edit
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save 
        current_user.projects << @project
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to project_path(@project) }
        format.xml { head :created, :location => project_path(@project) }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @project.errors.to_xml }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    unless @project = ProjectPermission.find_project_for_user( params[:id], current_user )
      redirect_to dashboard_path
      return
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        @project.users.clear
        User.find( params[:users] ).each { |u| @project.users << u } unless params[:users].blank?
        
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to project_path(@project) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project.errors.to_xml }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = ProjectPermission.find_project_for_user( params[:id], current_user )
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.xml { head :ok }
    end
  end
end
