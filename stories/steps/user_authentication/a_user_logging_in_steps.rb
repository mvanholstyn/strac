steps_for :a_user_logging_in do
  Given "a user at the login page" do
    get login_path
  end
  When "they login unsuccessfully" do
    submit_login_form do |form|
      form.user.email_address = "bademail"
      form.user.password = "bad password"
    end
  end
  Then "they see an error" do
    response.should have_tag("#error")
  end
  Then "remain on the login page" do
    response.should have_tag('form#login_form')
  end
  
  Given "a user with an account at the login page" do
    get login_path
  end
  When "they login successfully" do
    @user = Generate.active_user(:email_address => "newuser3@jones.com", :password=>"password", :password_confirmation=>"password")
    submit_login_form do |form|
      form.user.email_address = @user.email_address
      form.user.password = "password"
    end
  end
  Then "they see they are logged in" do
    response.should have_tag('.logged_in a[href=?]', profile_path)
  end  
end