require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats w/Completed Stories", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_project_stats_when_there_are_completed_stories_added_to_a_past_iteration, :project_stats],
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "there are completed stories added to an already completed iteration" do
    Given "that completed stories are added to a completed iteration"
    When "a user views the project summary"
    Then "they will see the sum of total points for the project" 
    And "they will the correct number of completed points for the project" 
    And "they will see the correct number of remaining points for the project"
    And "they will see 1 completed iterations"
    And "they will see the sum of completed points for the iteration as the average velocity for the project" 
    And "they will see the correct number of estimated remaining iterations for the project"
    And "they will see the correct estimated completion date based on a 1 week iteration" 
  end
end