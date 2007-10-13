require File.expand_path(File.dirname(__FILE__) + "/all")

Story "User Login", %|
  As a User
  I want to be able to login
  So that I can access projects I have interest in
|, :type => RailsStory do
  
  Scenario "User with invalid credentials" do
    Given "a user" do
       @user = Generate.user("bob@jones.com")
    end
    When "they try to login" do
      try_to_login
    end
    Then "they see an error" do
      response.should have_tag("#error")
    end
    And "remain on the login page" do
      response.should render_template("users/login")
    end
  end
  
  Scenario "User with good credentials who has not been activated" do
    Given "a user" do
       @user = Generate.user("bob@jones.com", :password=>"password", :password_confirmation=>"password")
    end
    When "they try to login" do
      get "/users/login"
      submit_form "login_form" do |form|
        form.user.email_address = @user.email_address
        form.user.password = "password"
      end
    end
    Then "they see an error" do
      response.should have_tag("#error")
    end
    And "remain on the login page" do
      response.should render_template("users/login")
    end
  end

  Scenario "User with good credentials who has been activated" do
    Given "a user" do
       @user = Generate.active_user("bob@jones.com", :password=>"password", :password_confirmation=>"password")
    end
    When "they try to login" do
      get "/users/login"
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