require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Story Tags", %|
  As a user 
  I should be able to view stories grouped by tags
  so that I can see stories in tag-based organization|, 
  :type => RailsStory do

  Scenario "viewing by tags on the stories page" do
    Given "there are no stories in the system" do
      there_are_no_stories_in_the_system
    end
    And "a user is viewing the stories page of a project" do
      a_user_viewing_the_stories_page_of_a_project
    end
    When "they click on the tag based view link" do
      click_tag_based_view_link 
    end
    Then "they see an empty list of stories"
    
    Given "two stories are added with the tag 'foo' (2)"
    And "a user is viewing the stories page of a project (2)"
    When "they click on the tag based view link (2)"
    Then "they will see a foo tag header (2)"
    And "they will see the two stories under the foo tag header (2)"
    
    Given "two more stories are added with the tag 'bar' (3)"
    And "a user is viewing the stories page of a project (3)"
    When "they click on the tag based view link (3)"
    Then "they will see a bar tag header (3)"
    And "they will see the two new stories under the bar tag header (3)"
    And "they will see the foo tag header (3)"
    And "they will see the two original stories under foo tag header (3)"
  end
  
  
  def click_tag_based_view_link
    click_link ".tag_based_view"
  end

end