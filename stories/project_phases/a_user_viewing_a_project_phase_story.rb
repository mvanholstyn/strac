require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Project Phases", %|
  As a user 
  I should be able to view a project phase
  so that I can manage a wish list of features for the future.|, 
  :steps_for => [:project_phases, :navigation],
  :type => RailsStory do

  Scenario "a user viewing an individual phase that has no stories" do
    Given "a phase with no stories exists in the system"
    When "a user goes to that phase"
    Then "they will see the phase's name"
    And "they will see the phase's description"
    And "they will see an empty stories list"
  end  
end