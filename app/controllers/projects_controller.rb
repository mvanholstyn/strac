class ProjectsController < ApplicationController
  restrict_to :user
  
  def chart
    @project=ProjectPermission.find_project_for_user(params[:id], current_user)
    total_points = []
    points_completed = []
    points_remaining = []
    
    iterations = @project.iterations.sort_by{ |iteration| iteration.started_at }
    iterations.each do |iteration|
      points_completed << iteration.snapshot.completed_points
      points_remaining << iteration.snapshot.remaining_points
      total_points << iteration.snapshot.total_points
    end
    points_completed << @project.completed_points
    points_remaining << @project.remaining_points
    total_points << @project.total_points

    step_count = 6
    min = 0
    max = (points_completed + total_points + points_remaining).max
    step = max / step_count.to_f
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    xlabels = iterations.map{ |e| iterations.index(e) } + ["current"]

    red = 'FF0000'
    yellow = 'FFFF00'
    green = '00FF00'
    blue = '0000FF'
    
    chart = Gchart.new(
     :data =>       [total_points, points_remaining, points_completed], 
     :bar_colors => [blue,         green,            yellow],
     :size => "600x200",
     :axis_with_labels => ["x", "y"],
     :axis_labels => [xlabels, ylabels],
     :legend => ["Total Points", "Points Remaining", "Total Points Completed"]
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
