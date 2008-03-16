require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Project Phases", %|
  As a user 
  I should be able to create and assign stories to phases 
  so that I can manage a wish list of features for the future.|, 
  :steps_for => [:project_phases, :navigation],
  :type => RailsStory do

  Scenario "a user creating a phase" do
    Given "a user is viewing a project's phases list"
    When  "they click on the create phase link"
    Then "they will be presented with the create a phase form" 
      
    When "they submit the create a phase form with invalid information" 
    Then "they will see project phase errors" 
    And "they still see the create a phase form"
  
    When "they submit the create a phase form with valid information" 
    Then "they will see the newly created phase"
  end
end