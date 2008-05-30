class IterationsController < ApplicationController
  def create
    if @project=ProjectPermission.find_project_for_user(params[:project_id], current_user)
      iterations = @project.iterations
      current_iteration = iterations.current
      if current_iteration 
        current_iteration.update_attribute(:ended_at, Time.now - 1.second)
      end
      new_current_iteration = iterations.find_or_build_current
      new_current_iteration.build_snapshot(
        :total_points => @project.total_points,
        :completed_points => @project.completed_points,
        :remaining_points => @project.remaining_points,
        :average_velocity => @project.average_velocity,
        :estimated_remaining_iterations => @project.estimated_remaining_iterations,
        :estimated_completion_date => @project.estimated_completion_date)
      new_current_iteration.save!
      flash[:notice] = %|Successfully started "#{new_current_iteration.name}".|
      redirect_to workspace_project_path(@project)
    else
      redirect_to "/access_denied.html"
    end
  end
end
