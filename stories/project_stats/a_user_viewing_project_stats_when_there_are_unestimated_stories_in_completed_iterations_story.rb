require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "a project with a completed iteration where none of its stories were estimated" do
    Given "there is a project with a completed iteration where none of its stories were estimated" do
      destroy_stories_and_iterations
      @project = Generate.project
      @iteration = Generate.iteration "already completed", :project => @project, :start_date => 1.week.ago, :end_date => 1.day.ago
      @stories = generate_unestimated_stories_for_project @project
      move_stories_to_iteration @stories, @iteration
    end
    When "a user views the project summary" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see zero total points for the project" do
      see_zero_total_points
    end
    And "they will see zero completed points for the project" do
      see_zero_completed_points
    end
    And "they will see zero remaining points for the project" do
      see_zero_remaining_points
    end
    And "they will see one completed iterations" do
      see_completed_iterations 1
    end
    And "they will see zero as the average velocity for the project" do
      see_zero_average_velocity
    end
    And "they will zero estimated remaining iterations for the project" do
      see_zero_estimated_remaining_iterations
    end
    And "they will see today the estimated completion date for the project" do
      see_today_as_the_estimated_completion_date
    end
  end

end