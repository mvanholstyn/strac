require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Project Phases", %|
  As a user 
  I should be able to add a story to a project phase
  so that I can manage a wish list of features for the future.|, 
  :steps_for => [:project_phases, :navigation],
  :type => RailsStory do

  Scenario "adding a story to a phase" do
    Given "a phase with no stories exists in the system" 
    And "a story exists in the system for the same project"
    And "a user is editing the story"
    When "they update the story to belong to the phase" 
    Then "they see the story show page" # TODO: the view needs to be updated to use dom_id for showing the story so we can ensure its presenter
    
    When "a user goes to that phase"
    Then "they will see the story in the stories list" 
  end

end