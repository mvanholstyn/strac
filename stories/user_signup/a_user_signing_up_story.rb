require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "User Signup", %|
  As a User
  I want to be able to sign up
  So that I may be able to enjoy agile project management in strac!|, 
  :steps_for => [:a_user_signing_up],
  :type => RailsStory do
  
  Scenario "Sending invitations" do
    Given "a user at the login page"
    When "they click on the signup link"
    Then "they will see the signup form"
    
    Given "a user viewing the signup form"
    When "they submit the form with acceptable data"
    Then "they will be logged in"
  end
  
end