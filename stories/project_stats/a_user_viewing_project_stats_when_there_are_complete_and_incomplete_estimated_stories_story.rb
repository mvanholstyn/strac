require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_project_stats_when_there_are_complete_and_incomplete_estimated_stories, :project_stats],
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "there are estimated stories, both complete and incomplete" do
    Given "a project exists with both complete and incomplete stories"
    When "a user views the project summary"
    Then "they will see the sum of total points for the project"
    And "they will the correct number of completed points for the project" 
    And "they will see the correct number of remaining points for the project" 
    And "they will see zero completed iterations"
    And "they will see zero as the average velocity for the project"
    And "they will zero estimated remaining iterations for the project"
    And "they will see today the estimated completion date for the project"
  end
end

