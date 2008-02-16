require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "there are completed stories added to an already completed iteration" do
    Given "the completed stories are added to a completed iteration" do
      destroy_stories_and_iterations
      @project = Generate.project
      @stories = generate_estimated_stories_for_project @project
      @completed_stories = make_stories_completed @stories[0..1]
      @incomplete_stories = @stories[2..-1]
      @iteration = Generate.iteration("Iteration 1", :project => @project, :start_date => 1.week.ago, :end_date => Time.now.yesterday)
      move_stories_to_iteration @completed_stories, @iteration
    end
    When "the user views the project summary" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see the sum of total points for the project" do
      see_total_points @stories.sum(&:points)
    end
    And "they will the correct number of completed points for the project" do
      see_completed_points @completed_stories.sum(&:points)
    end
    And "they will see the correct number of remaining points for the project" do
      @remaining_points = @incomplete_stories.sum(&:points)
      see_remaining_points @remaining_points
    end
    And "they will see one completed iterations" do
      see_completed_iterations 1
    end
    And "they will see the sum of completed points for the iteration as the average velocity for the project" do
      @average_velocity = @completed_stories.sum(&:points)
      see_average_velocity @average_velocity
    end
    And "they will see the correct number of estimated remaining iterations for the project" do
      @remaining_iterations = @stories.sum(&:points) / @completed_stories.sum(&:points) 
      see_estimated_remaining_iterations @remaining_iterations
    end
    And "they will see the correct estimated completion date based on a 1 week iteration" do
      @remaining_iterations = @remaining_points.to_f / @average_velocity.to_f
      date = Date.today + @remaining_iterations * 7 
      see_estimated_completion_date date
    end
  end
end