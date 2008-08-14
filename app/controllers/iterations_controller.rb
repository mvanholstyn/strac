class IterationsController < ApplicationController
  restrict_to :user

  def create
    if @project=ProjectPermission.find_project_for_user(params[:project_id], current_user)
      iteration = @project.start_new_iteration!
      flash[:notice] = %|Successfully started "#{iteration.name}".|
      redirect_to workspace_project_path(@project)
    else
      redirect_to "/access_denied.html"
    end
  end
end
