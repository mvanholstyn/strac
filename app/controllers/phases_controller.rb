class PhasesController < ApplicationController
  before_filter :find_project

  def index
    @phases = @project.phases.find(:all, :order => "name")
  end
  
  def new
    @phase = @project.phases.build
  end

  def create
    @phase = @project.phases.build(params[:phase])
    if @phase.save
      flash[:notice] = 'phase was successfully created.'
      redirect_to project_phase_path(@project, @phase)
    else
      flash[:error] = 'phase failed to create.'
      render :action => "new"
    end
  end

  def show
    @phase = @project.phases.find(params[:id])
  end

  def edit
    @phase = @project.phases.find(params[:id])
  end

  def update
    @phase = @project.phases.find(params[:id])

    if @phase.update_attributes(params[:phase])
      flash[:notice] = 'phase was successfully updated.'
      redirect_to project_phase_path(@project, @phase)
    else
      render :action => "edit"
    end
  end

  def destroy
    @phase = @project.phases.find(params[:id])
    @phase.destroy
    redirect_to project_phases_url(@project)
  end

private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
