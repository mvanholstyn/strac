class ProjectsController < ApplicationController
  restrict_to :user
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Strac::ProjectManager.all_projects_for_user current_user

    respond_to do |format|
      format.html
      format.xml { render :xml => @projects.to_xml }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    # @project = ProjectPermission.find_project_for_user( params[:id], current_user )
    # 
    @project = Strac::ProjectManager.get_project_for_user(params[:id], current_user)
    respond_to do |format|
      format.html
      format.xml { 
        render :xml => @project.to_xml
       }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1;edit
  def edit
    @project = Strac::ProjectManager.get_project_for_user(params[:id], current_user)
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
    Strac::ProjectManager.update_project_for_user(params[:id], current_user) do |project_update|
      respond_to do |format|
        @project = project_update.project
        project_update.success do
          flash[:notice] = 'Project was successfully updated.'
          format.html { redirect_to project_path(@project) }
          format.xml { head :ok }
        end
      
        project_update.failure do
          format.html { render :action => "edit" }          
          format.xml { render :xml => @project.errors.to_xml }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Strac::ProjectManager.get_project_for_user(params[:id], current_user)
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.xml { head :ok }
    end
  end
end
