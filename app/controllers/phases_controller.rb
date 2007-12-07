class PhasesController < ApplicationController
  # before_filter :find_project

  def index
  end

  private 
  
  # def find_project
  #   @project = Project.find( params[:project_id] )#, :include => { :iterations => { :stories => :tags } } )
  # end

end