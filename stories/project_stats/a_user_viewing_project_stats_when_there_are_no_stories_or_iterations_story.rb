require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats w/No Stories or Iterations", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_project_stats_when_there_are_no_stories_or_iterations, :project_stats],
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "a project with no stories or iterations" do
    Given "there are no iterations or stories which belong to that project"
    When "a user views the project summary" 
    Then "they will see 0 total points for the project" 
    And "they will see 0 completed points for the project"
    And "they will see 0 remaining points for the project"
    And "they will see 0 completed iterations"
    And "they will see 0 as the average velocity for the project"
    And "they will see 0 estimated remaining iterations for the project" 
    And "they will see today the estimated completion date for the project"
  end

end