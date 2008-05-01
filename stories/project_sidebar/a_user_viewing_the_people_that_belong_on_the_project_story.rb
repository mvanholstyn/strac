require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "A Project's People Sidebar", %|
  As a user 
  I want to be able to see who else is apart of the project|, 
  :steps_for => [:a_user_viewing_the_people_that_belong_on_the_project, :navigation],
  :type => RailsStory do

  Scenario "Viewing people apart of the project" do
    Given "a project with users"
    And "one of of those users logs in"
    When "they navigate to the project"
    Then "they will see that each user is listed in the sidebar"
  end
    
end