require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats w/Incomplete Estimated Stories", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_project_stats_when_there_are_incomplete_estimated_stories, :project_stats],
  :type => RailsStory do
  extend ProjectStatsStoryHelper
  
  Scenario "a project with incomplete, estimated stories" do
    Given "there are incomplete, estimated stories added to the project"
    When "a user views the project summary" 
    Then "they will see the sum of total points for the project" 
    And "they will see 0 completed points for the project" 
    And "they will see remaining points for the project"
    And "they will see 0 completed iterations"
    And "they will see 0 as the average velocity for the project"
    And "they will see 0 estimated remaining iterations for the project" 
    And "they will see today the estimated completion date for the project"
  end
end