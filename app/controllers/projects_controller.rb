class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    @chart = Project::Chart.new @project
    
    chart = Gchart.new(
     :data =>       @chart.data, 
     :bar_colors => @chart.colors,
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [@chart.xlabels, @chart.ylabels],
     :legend => @chart.legend
    )
    
    render :text => chart.send!(:fetch)
  end

  def index
    @projects = ProjectManager.all_projects_for_user current_user
  end

  def show
    @project = ProjectManager.get_project_for_user(params[:id], current_user)
  end

  def new
    @project = Project.new
  end

  def edit
    @project = ProjectManager.get_project_for_user(params[:id], current_user)
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
    @project = ProjectManager.get_project_for_user(params[:id], current_user)
    @project.destroy
    redirect_to projects_path
  end
  
  def workspace
    @project = ProjectManager.get_project_for_user(params[:id], current_user)
    @stories = @project.incomplete_stories
  end
end
