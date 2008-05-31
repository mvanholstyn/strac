steps_for :a_user_updating_their_profile do
  Given "a user at the profile page" do
    @user = Generate.user
    a_user_viewing_a_project :user => @user
    click_profile_link
  end

  When "they update their profile successfully" do
    submit_profile_form(@user) do |form|
      form.user.first_name = "Earl"
      form.user.last_name = "Jones"
    end
    follow_all_redirects
  end
  
  Then "they'll be notified of the successful update" do
    response.should have_text("Your profile was successfully updated.".to_regexp)
  end
end
