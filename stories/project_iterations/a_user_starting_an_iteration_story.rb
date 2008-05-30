require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Starting an iteration", %|
  As a User I want to be able to mark stories as completed.|, 
  :steps_for => [:a_user_starting_an_iteration],
  :type => RailsStory do

  Scenario "a user starting the first iteration" do
    Given "there is a project with incomplete, but estimated stories and no iterations"
    And "a logged in user accesses the project's workspace page"
    When "they click on the start iteration link"
    Then "they will see that the current iteration just started"
    And "the current iteration will create a snapshot of the total number of points for the project"
    And "the current iteration will create a snapshot of the total number of completed points for the project"
    And "the current iteration will create a snapshot of the total number of remaining points for the project"
    And "the current iteration will create a snapshot of the average velocity for the project"
    And "the current iteration will create a snapshot of the estimated remaining iterations"
    And "the current iteration will create a snapshot of the estimated completion date"
  end
  
  Scenario "a user starting another iteration" do
    Given "there is a project with a current iteration that has incomplete and complete stories"
    And "a logged in user accesses the project's workspace page"
    When "they click on the start iteration link"
    Then "they will see that the current iteration just started"
    And "the previous iteration will have been updated to have ended just moments ago"
    And "the current iteration will create a snapshot of the total number of points for the project"
    And "the current iteration will create a snapshot of the total number of completed points for the project"
    And "the current iteration will create a snapshot of the total number of remaining points for the project"
    And "the current iteration will create a snapshot of the average velocity for the project"
    And "the current iteration will create a snapshot of the estimated remaining iterations"
    And "the current iteration will create a snapshot of the estimated completion date"
  end
end