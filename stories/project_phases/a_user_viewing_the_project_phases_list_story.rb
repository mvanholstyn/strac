require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Project Phases", %|
  As a user 
  I should be able to view a list of project phases
  so that I can manage a wish list of features for the future.|, 
  :steps_for => [:project_phases, :navigation],
  :type => RailsStory do

  Scenario "viewing an empty phases list" do
    Given "a user viewing a project" 
    When "they click on the phases link" 
    Then "they will see an empty phases list"
  end
end