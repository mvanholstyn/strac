require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to create and assign stories to phases 
  so that I can manage a wishlist of features for the future.|, 
  :steps_for => [:navigation, :project_stats],
  :type => RailsStory do
    
  Scenario "how the project summary is affected by adding a completed story to a phase" do
    Given "a completed story exists that does not belong to a phase"
    And "a user viewing that story's project"
    When "they move the completed story to a phase" 
    Then "they will see the points for that story are removed from the total points and completed points"
  end
  
  Scenario "how the project summary is affected by adding an incomplete story to a phase" do
    Given "an incomplete story exists that has been estimated"
    And "a user viewing that story's project"
    When "they move the incomplete story to a phase"
    Then "they will see the points for that story are removed from the total points and remaining points"
  end
    
end
