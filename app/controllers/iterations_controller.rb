class IterationsController < ApplicationController
  before_filter :find_project

  def index
    @iterations = @project.iterations.find(:all, :order => "start_date DESC")
  end

  def show
    @iteration = @project.iterations.find(params[:id])
  end

  def new
    @iteration = @project.iterations.build
  end

  def edit
    @iteration = @project.iterations.find(params[:id])
  end

  def create
    @iteration = @project.iterations.build(params[:iteration])

    if @iteration.save
      flash[:notice] = 'Iteration was successfully created.'
      redirect_to iteration_url(@project, @iteration)
    else
      render :action => "new"
    end
  end

  def update
    @iteration = @project.iterations.find(params[:id])

    if @iteration.update_attributes(params[:iteration])
      flash[:notice] = 'Iteration was successfully updated.'
      redirect_to iteration_path(@project, @iteration)
    else
      render :action => "edit"
    end
  end

  def destroy
    @iteration = @project.iterations.find(params[:id])
    @iteration.destroy

    redirect_to iterations_url(@project)
  end
  
  def current
    @iteration = @project.iterations.find_or_build_current
    @stories = @project.stories.find(:all, :conditions => { :bucket_id => nil }, :order => :position)
  end

private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
