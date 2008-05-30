require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Creating/Updating/Reading/Destroying a Project", %|
  As a user 
  I want to be able to CRUD a project|, 
  :steps_for => [:a_user_crudding_a_project_steps],
  :type => RailsStory do

  Scenario "a user creating a project" do
    Given "there are no projects in the system" 
    And "a logged in user"
    When "they click the projects link"
    Then "they will see an empty projects list"
    
    When "they click on the new project link"
    And "they submit the new project form without any information" 
    Then "they will see an error stating that the project name is required"
    
    When "they submit the new project form with the required information"
    Then "they will see a message telling them the project was successfully created"
    And "they will see the project"
    
    When "they click the projects link"
    Then "they will see the project in the project list"
  end

  Scenario "a user trying to view a project who doesn't have permission" do
    Given "a logged in user"
    When "they try to view a project they don't have permission to access"
    Then "they will see an error telling them they can't access the resource"
  end
  
  Scenario "Updating a project" do
    GivenScenario "a user creating a project"
    When "they click on the edit link for the newly created project"
    Then "they will see the edit project form"
    
    When "they submit the edit project form without any information" 
    Then "they will see an error stating that the project name is required"
    
    When "they submit the project form with an updated name" 
    Then "they will see the project"
    
    When "they click the projects link"
    Then "they will see the project in the project list"
  end
  
  Scenario "a user trying to edit a project who doesn't have permission" do
    Given "a logged in user"
    When "they try to edit a project they don't have permission to access"
    Then "they will see an error telling them they can't access the resource"
  end
  
  Scenario "a user trying to update a project who doesn't have permission" do
    Given "a logged in user"
    When "they try to update a project they don't have permission to access"
    Then "they will see an error telling them they can't access the resource"
  end
  
  Scenario "Accessing a project through the dashboard" do
    GivenScenario "a user creating a project"
    When "they click the dashboard link"
    Then "they will see a link to the project"
    
    When "they click on the link to the project"
    Then "they will see the project"
  end
  
  Scenario "Accessing a project through the projects list" do
    GivenScenario "a user creating a project"
    When "they click the projects link"
    Then "they will see a link to the project"
    
    When "they click on the link to the project"
    Then "they will see the project"
  end
  
  Scenario "Destroying a project" do
    GivenScenario "a user creating a project"
    When "they click the projects link"
    Then "they will see a link to destroy the project"
    
    When "they click on the link to destroy the project"
    Then "they will see the projects list"
    And "they will not see the destroyed project in the projects list"
  end
  
  Scenario "a user trying to destroy a project who doesn't have permission" do
    Given "a logged in user"
    When "they try to destroy a project they don't have permission to access"
    Then "they will see an error telling them they can't access the resource"
  end
  
  Scenario "a user trying to view a project's workspace who doesn't have permission" do
    Given "a logged in user"
    When "they try to view a project's workspace they don't have permission to access"
    Then "they will see an error telling them they can't access the resource"
  end

end