steps_for :project_stats do
  Given "a completed story exists that does not belong to a phase" do
    @phase = Generate.phase "Another Day Another Phase", :description => "woohah"
    @story = Generate.story :summary => "story1", :project => @phase.project, :points => 10, :status => Status.complete
  end
  Given "a user viewing that story's project" do
    a_user_viewing_a_project(:project => @phase.project)
    @total_points = grab_project_summary(".total_points").to_i
    @completed_points = grab_project_summary(".completed_points").to_i
    @remaining_points = grab_project_summary(".remaining_points").to_i
  end
  Given "an incomplete story exists that has been estimated" do
    @phase = Generate.phase "Another Day Another Phase", :description => "woohah"
    @story = Generate.story :summary => "story1", :project => @phase.project, :points => 10
  end


  When "a user views the project summary" do
    a_user_viewing_a_project :project => @project
  end
  When "they move the completed story to a phase" do
    move_story_to_phase(@story, @phase)
  end
  When "they move the incomplete story to a phase" do
    move_story_to_phase(@story, @phase)
  end
  

  Then "they will see the points for that story are removed from the total points and completed points" do
    updated_total_points = grab_project_summary(".total_points").to_i
    updated_total_points.should == @total_points - @story.points
    updated_completed_points = grab_project_summary(".completed_points").to_i
    updated_completed_points.should == @completed_points - @story.points
  end
  Then "they will see the points for that story are removed from the total points and remaining points" do
    updated_total_points = grab_project_summary(".total_points").to_i
    updated_total_points.should == @total_points - @story.points
    updated_remaining_points = grab_project_summary(".remaining_points").to_i
    updated_remaining_points.should == @remaining_points - @story.points 
  end
  Then "they will see zero completed iterations" do
    see_zero_completed_iterations
  end
  Then "they will see zero completed points for the project" do
    see_completed_points 0
  end
  Then "they will see zero as the average velocity for the project" do
    see_zero_average_velocity
  end
  Then "they will zero estimated remaining iterations for the project" do
    see_zero_estimated_remaining_iterations
  end
  Then "they will see today the estimated completion date for the project" do
    see_today_as_the_estimated_completion_date
  end
  Then "they will see the sum of total points for the project" do
    see_total_points @stories.sum(&:points)
  end
  Then "they will the correct number of completed points for the project" do
    see_completed_points @completed_stories.sum(&:points)
  end
  Then "they will see the correct number of remaining points for the project" do
    see_remaining_points @incomplete_stories.sum(&:points)
  end
  Then "they will see remaining points for the project" do
    see_remaining_points @stories.sum(&:points)
  end

  
end