module Project::Statistics

  def total_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND (status_id NOT IN (?) OR status_id IS NULL)", 
          Iteration.name, [Status.rejected.id]] ) 
    sum || 0
  end
  
  def completed_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND status_id IN (?)", 
        Iteration.name, [Status.complete.id] ] ) 
    sum || 0
  end
  
  def remaining_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND (status_id NOT IN (?) OR status_id IS NULL)",
         Iteration.name, [Status.complete.id, Status.rejected.id] ] )
    sum || 0
  end
  
  def average_velocity
    points = previous_iterations.inject([]) do |points, iteration|
      points << iteration.points_completed
    end
    VelocityCalculator.compute_weighted_average(points)
  end
  
  def estimated_remaining_iterations
    average_velocity.zero? ? 0 : remaining_points.to_f / average_velocity.to_f
  end
  
  def estimated_completion_date
    Date.today + estimated_remaining_iterations * 7
  end
  
end