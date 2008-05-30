steps_for :a_user_viewing_project_stats_when_there_are_completed_stories_added_to_a_past_iteration do
  Given "that completed stories are added to a completed iteration" do
    destroy_stories_and_iterations
    @project = Generate.project
    @stories = generate_estimated_stories_for_project @project
    @completed_stories = make_stories_completed @stories[0..1]
    @incomplete_stories = @stories[2..-1]
    @iteration = Generate.iteration(:name => "Iteration 1", :project => @project, :started_at => 1.week.ago, :ended_at => Time.now.yesterday)
    move_stories_to_iteration @completed_stories, @iteration
  end
  
  
  Then "they will see the correct number of remaining points for the project" do
    @remaining_points = @incomplete_stories.sum(&:points)
    see_remaining_points @remaining_points
  end
  Then "they will see 1 completed iterations" do
    see_completed_iterations 1
  end
  Then "they will see the sum of completed points for the iteration as the average velocity for the project" do
    @average_velocity = @completed_stories.sum(&:points)
    see_average_velocity @average_velocity
  end
  Then "they will see the correct number of estimated remaining iterations for the project" do
    @estimated_remaining_iterations = @remaining_points.to_f / @average_velocity
    see_estimated_remaining_iterations @estimated_remaining_iterations.ceil
  end
  Then "they will see the correct estimated completion date based on a 1 week iteration" do
    @estimated_remaining_iterations = @remaining_points.to_f / @average_velocity.to_f
    date = Date.today + @estimated_remaining_iterations * 7 
    see_estimated_completion_date date
  end

end