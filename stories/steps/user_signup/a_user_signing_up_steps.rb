steps_for :a_user_signing_up do
  Given "a user at the login page" do 
    a_user_at_the_login_page
  end
  Given "a user viewing the signup form" do
    see_signup_form
  end


  When "they click on the signup link" do
    click_signup_link
  end
  When "they submit the form with acceptable data" do
    submit_signup_form :email_address => "zach.dennis@gmail.com"
  end


  Then "they will see the signup form" do
    see_signup_form 
  end  
  Then "they will be logged in" do
    see_the_user_has_logged_in "zach.dennis@gmail.com"
  end
end