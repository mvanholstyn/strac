require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Chart", %|
  As a user 
  I want to see a project burndown chart
  so that I can view important information about my project quickly.|, 
  :steps_for => [:a_user_viewing_a_project_chart, :project_stats],
  :type => RailsStory do
    
  Scenario "a project with no estimated stories" do
    Given "there is a project with no estimated stories"
    When "a user views the project"
    Then "won't see a project burndown chart"
  end

  Scenario "a project with estimated stories" do
    Given "there is a project with estimated stories"
    When "a user views the project"
    Then "see a project burndown chart"
  end

end

