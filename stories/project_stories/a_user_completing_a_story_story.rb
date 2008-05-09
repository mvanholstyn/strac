require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Completing Project Stories", %|
  As a User I want to be able to mark stories as completed.|, 
  :steps_for => [:a_user_completing_a_story],
  :type => RailsStory do

  Scenario "marking a story complete by updating its status" do
    Given "there is a project with a running iteration and incomplete stories"
    And "a logged in user accesses the project"
    When "they update the status of the story to complete"
    Then "the story will be marked as completed"
    And "the story will belong to the currently running iteration"
  end

end