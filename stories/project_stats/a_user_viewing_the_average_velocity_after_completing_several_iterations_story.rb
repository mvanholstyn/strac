require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats Average Velocity", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_the_average_velocity_after_completing_several_iterations, :project_stats],
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "a user completes several iterations and watches the average velocity" do
    Given "there is a project with no stories or iterations"
    When "a user views the project summary"
    Then "they will see 0 as the average velocity for the project"
    
    Given "the user completes an iteration worth 10 points" 
    When "a user views the project summary"
    Then "they will see 10 as the average velocity for the project" 
    
    Given "the user completes another iteration worth 10 points"
    When "a user views the project summary"
    Then "they will see 10 as the average velocity for the project"
    
    Given "the user completes another iteration worth 10 points" 
    When "a user views the project summary"
    Then "they will see 10 as the average velocity for the project"
    
    Given "the user completes another iteration worth 40 points"
    When "a user views the project summary"
    Then "they will see 25 as the average velocity for the project" 
    
    Given "the user completes another iteration worth 35 points"
    When "a user views the project summary"
    Then "they will see 30 as the average velocity for the project" 
    
    Given "the user completes another iteration worth 47 points" 
    When "a user views the project summary"
    Then "they will see 38 as the average velocity for the project" 
    
    Given "the user completes another iteration worth 47 points"
    When "a user views the project summary"
    Then "they will see 42 as the average velocity for the project"
  end
end