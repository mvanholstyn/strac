class PhasesController < ApplicationController
  before_filter :find_project

  def index
    @phases = @project.phases
  end

  def new
    @phase = @project.phases.build
    respond_to do |format|
      format.js{ render :action => "new.js.rjs" }
    end
  end
  
  def create
    @phase = @project.phases.build(params[:phase])
    respond_to do |format|
      format.js do
        if @phase.save
          flash[:notice] = "The phase has been created successfully"
        else
          flash[:error] = "The phase could not be created."
        end
        render :template => "phases/create.js.rjs"
      end
    end
  end

  private 
  
  def find_project
    @project = Project.find( params[:project_id] )
  end

end