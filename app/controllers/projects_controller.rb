class ProjectsController < ApplicationController
  restrict_to :user
  
  def index
    @projects = ProjectPermission.find_all_projects_for_user(current_user)
  end

  def show
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      raise AccessDenied
    end
  end

  def new
    @project = Project.new
  end

  def edit
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      redirect_to "/access_denied.html"
    end
  end

  def create
    @project = Project.new(params[:project])
    
    if @project.save 
      current_user.projects << @project
      flash[:notice] = 'Project was successfully created.'
      redirect_to project_path(@project)
    else
      render :action => "new"
    end
  end

  def update
    ProjectManager.update_project_for_user(params[:id], current_user, params[:project], params[:users]) do |project_update|
      project_update.success do |project|
        @project = project
        flash[:notice] = 'Project was successfully updated.'
        redirect_to project_path(@project)
      end
      
      project_update.failure do |project|
        @project = project
        render :action => "edit"
      end
    end
  end

  def destroy
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @project
    else
      redirect_to "/access_denied.html"
    end
    @project.destroy
    redirect_to projects_path
  end
  
  def workspace
    if @project=ProjectPermission.find_project_for_user(params[:id], current_user)
      @stories = @project.incomplete_stories
    else
      redirect_to "/access_denied.html"
    end
  end
end
