class ProjectPresenter < PresentationObject
  def initialize(options)
    @project = options[:project]
  end
  
  delegate :class, :id, :errors, :new_record?, :to_param,
           :completed_points, :remaining_points, :total_points,
           :completed_iterations, :average_velocity, 
           :estimated_remaining_iterations, :estimated_completion_date,
           :iterations, :name, :recent_activities, :users,
           :to => :@project
           
  declare :display_chart? do
    @project.total_points > 0
  end
  
end