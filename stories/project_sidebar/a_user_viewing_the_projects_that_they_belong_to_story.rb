require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "A User's Project Sidebar", %|
  As a user 
  I want to be able to see what projects I belong to|, 
  :steps_for => [:a_user_viewing_the_projects_that_they_belong_to],
  :type => RailsStory do

  Scenario "a user who doesn't belong to any projects" do
    Given "a user without any projects logs in"
    When "they look at the sidebar"
    Then "they will see no projects that they belong to in the sidebar"
  end

  Scenario "a user who belongs to some projects" do
    Given "a user who belongs to some projects logs in"
    When "they look at the sidebar"
    Then "they will see that they projects that they belong to in the sidebar"
  end
    
end