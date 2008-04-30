require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Story Tags", %|
  As a user 
  I should be able to view stories grouped by tags
  so that I can see stories in tag-based organization|, 
  :steps_for => [:a_user_using_story_tags],
  :type => RailsStory do

  Scenario "viewing by tags on the stories page" do
    Given "there are no stories in the system" 
    And "a user goes to the stories page of a project"
    When "they click on the tag based view link"
    Then "they see an empty list of stories"
    
    Given "two stories are added with the tag 'foo'"
    And "the user goes to the stories page of the project"
    When "they click on the tag based view link"
    Then "they will see the foo tag header"
    And "they will see the two stories under the foo tag header"
    
    Given "two more stories are added with the tag 'bar'"
    And "the user goes to the stories page of the project"
    When "they click on the tag based view link"
    Then "they will see the bar tag header"
    And "they will see the two new stories under the bar tag header"
    And "they will see the foo tag header"
    And "they will see the two stories under the foo tag header" 
  end
  
end