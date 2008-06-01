steps_for :a_user_updating_their_profile do
  Given "a user at the profile page" do
    @user = Generate.user :first_name => "Bob", :last_name => "Jones"
    a_user_viewing_a_project :user => @user
    click_profile_link
    response.should have_tag("form#user_form") do
      with_tag("input[id=user_first_name][value=?]", "Bob")
      with_tag("input[id=user_last_name][value=?]", "Jones")
    end
  end

  When "they update their profile successfully" do
    submit_profile_form(@user) do |form|
      form.user.first_name = "Earl"
      form.user.last_name = "Jones"
    end
    follow_all_redirects
  end
  When "they update their profile without first and last name" do
    submit_profile_form(@user) do |form|
      form.user.first_name = ""
      form.user.last_name = ""
    end
    follow_all_redirects    
  end
  
  Then "they'll be notified of the successful update" do
    response.should have_text("Your profile was successfully updated.".to_regexp)
  end
  Then "they'll be notified of errors regarding their profile" do
    see_an_error_explanation do |error|
      error.should exist_for("first name")
      error.should exist_for("last name")
    end
  end
end
