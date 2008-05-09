require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Reordering Project Stories", %|
  As a User
  I want to be able to reorder stories
  So I prioritize features.|, 
  :steps_for => [:a_user_reordering_stories],
  :type => RailsStory do

  Scenario "a user without access to a project reordering its stories" do
    Given "there is a project with stories"
    And "a logged in user without access to the project"
    When "the user reorders the stories"
    Then "the positions of the stories are not updated"
  end

  Scenario "a user with access reordering its stories" do
    Given "there is a project with stories"
    And "a logged in user accesses the project"
    When "the user reorders the stories"
    Then "the positions of the stories are updated"
  end
end
