require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Commenting Stories", %|
  As a User
  I want to be able to comment on a story.|, 
  :steps_for => [:a_user_commenting_a_story],
  :type => RailsStory do

  Scenario "a user adding a comment to a story" do
    Given "there is a project with stories"
    And "a logged in user accesses the project"
    When "the user creates a comment for a story"
    Then "they see the comment added to the story"
  end
end
