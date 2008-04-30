require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "User Login", %|
  As a User
  I want to be able to login
  So that I can access projects I have interest in
|, :type => RailsStory, :steps_for => [ :a_user_logging_in ] do
  
  Scenario "User with invalid credentials" do
    Given "a user at the login page" 
    When "they login unsuccessfully"
    Then "they see an error"
    And "remain on the login page"
  end
    
  Scenario "User with good credentials who has been activated" do
    Given "a user with an account at the login page"
    When "they login successfully"
    Then "they see they are logged in"
  end
end

