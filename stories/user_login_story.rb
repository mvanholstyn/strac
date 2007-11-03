require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "User Login", %|
  As a User
  I want to be able to login
  So that I can access projects I have interest in
|, :type => RailsStory do
  
  Scenario "User with invalid credentials" do
    Given "a user at the login page" do
      get login_path
    end
    When "they login unsuccessfully" do
      login_unsuccessfully
    end
    Then "they see an error" do
      response.should have_tag("#error")
    end
    And "remain on the login page" do
      response.should render_template("users/login")
    end
  end
    
  Scenario "User with good credentials who has been activated" do
    Given "a user at the login page" do
      get login_path
      @user = Generate.active_user("newuser3@jones.com", :password=>"password", :password_confirmation=>"password")
    end
    When "they login successfully" do
      submit_form "login_form" do |form|
        form.user.email_address = @user.email_address
        form.user.password = "password"
      end      
    end
    Then "they are redirected to to the dashboard page" do
      response.should redirect_to("/")
    end
  end

end

def login_unsuccessfully
  try_to_login("bad email", "bad password")
end

def try_to_login(email, password="password")
  submit_form "login_form" do |form|
    form.user.email_address = email
    form.user.password = password
  end
end