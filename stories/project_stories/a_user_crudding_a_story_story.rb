require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "CRUD'ing Stories", %|
  As a User
  I want to be able to CRUD stories.|, 
  :steps_for => [:a_user_crudding_a_story],
  :type => RailsStory do

  Scenario "a user with access creates a story" do
    Given "there is a project with stories"
    And "a logged in user accesses the project"
    When "the user creates a story"
    Then "the user is notified of success"
    And "the story list is updated"
  end
  
  Scenario "a user with access updates a story" do
    Given "there is a project with stories"
    And "a logged in user accesses the project"
    When "the user updates a story without enough information"
    Then "the user is notified of errors"
    
    When "the user updates a story with enough information"
    Then "the user is notified that the story was updated"
  end
end
