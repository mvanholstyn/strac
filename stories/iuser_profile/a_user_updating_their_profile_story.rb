require File.expand_path(File.dirname(__FILE__) + "/../helper")

Story "User Profile", %|
  As a User
  I want to be able to update my profile|, 
  :steps_for => [:a_user_updating_their_profile],
  :type => RailsStory do
    
  Scenario "a user successfully updating their profile" do
    Given "a user at the profile page"
    When "they update their profile successfully"
    Then "they'll be notified of the successful update"
  end

end
