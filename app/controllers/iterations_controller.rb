class IterationsController < ApplicationController
  def create
    if @project=ProjectPermission.find_project_for_user(params[:project_id], current_user)
      iterations = @project.iterations
      current_iteration = iterations.current
      if current_iteration 
        if current_iteration.start_date == Date.today
          flash[:error] = "You'll have to wait for two days to start another iteration."
          redirect_to workspace_project_path(@project)
          return
        elsif current_iteration.start_date == Date.yesterday
          flash[:error] = "You'll have to wait for one day to start another iteration."          
          redirect_to workspace_project_path(@project)
          return
        end
        current_iteration.update_attribute(:end_date, Date.yesterday)  
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
