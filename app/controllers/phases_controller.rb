class PhasesController < ApplicationController
  before_filter :find_project

  def index
    @phases = @project.phases.find(:all, :order => "name")

    respond_to do |format|
      format.html
      format.xml { render :xml => @phases.to_xml }
    end
  end
  
  def new
    @phase = @project.phases.build
  end

  def create
    @phase = @project.phases.build( params[:phase] )
    respond_to do |format|
      if @phase.save
        flash[:notice] = 'phase was successfully created.'
        format.html { redirect_to project_phase_path(@project, @phase) }
      else
        flash[:error] = 'phase failed to create.'
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @phase = @project.phases.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @phase.to_xml }
    end
  end

  def edit
    @phase = @project.phases.find(params[:id])
  end

  def update
    @phase = @project.phases.find(params[:id])

    respond_to do |format|
      if @phase.update_attributes(params[:phase])
        flash[:notice] = 'phase was successfully updated.'
        format.html { redirect_to project_phase_path(@project, @phase) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @phase = @project.phases.find(params[:id])
    @phase.destroy

    respond_to do |format|
      format.html { redirect_to project_phases_url( @project ) }
    end
  end

  private
  
  def find_project
    @project = Project.find( params[:project_id] )
  end
end
