require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "Project Invitations", %|
  As a User
  I want to be able to invite other users to a project
  So that they may share in fun and challenging experiences of the project itself.
|, :type => RailsStory, :steps_for => [ :a_user_sending_project_invitations ] do
    
  Scenario "Sending invitations to an existing user of the system" do
    Given "a user is viewing a project"
    When "they click on the 'invite people' link" 
    Then "they see an invitation form with text fields for email addresses and message body"
    
    Given "the user is viewing an invitation form"
    When "they fill out the invitation form and submit it" 
    Then "an email is sent to each email address specified"
    And "each email has an accept link" 
    And "each email contains the body that the user input"
  
    Given "an existing user received an email invitation" 
    When "they click on the invitation acceptance link" 
    Then "they are taken to a signup or login page"
    
    Given "the existing user is viewing the signup or login page"
    When "they login"
    And "they go to the dashboard page" 
    Then "they see a link which takes them to the project they accepted"
  end

  Scenario "Sending invitations to a user not in the system" do
    Given "a user is viewing a project"
    When "they click on the 'invite people' link"
    Then "they see an invitation form with text fields for email addresses and message body"
    
    Given "the user is viewing an invitation form"
    When "they fill out the invitation form and submit it"
    Then "an email is sent to each email address specified"
    And "each email has an accept link"
    And "each email contains the body that the user input"
  
    Given "a user received an email invitation" 
    When "they click on the invitation acceptance link"
    Then "they are taken to a signup or login page"
    
    Given "the user is viewing the signup or login page"
    When "they submit the create an account form with mismatched passwords" 
    Then "they see the errors regarding the mismatched passwords" 
  
    Given "the user is viewing the signup or login page" 
    When "they submit the create an account form"
    And "they go to the dashboard page"
    Then "they see a link which takes them to the project they accepted"
  end
          
end