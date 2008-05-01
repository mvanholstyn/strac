steps_for :a_user_viewing_the_people_that_belong_on_the_project do
  Given "a project with users" do
    @users = [
      Generate.user(:first_name => "Bob", :last_name => "Smith"),
      Generate.user(:first_name => "Stephen", :last_name => "Colbert"),
      Generate.user(:first_name => "Benjamin", :last_name => "Franklin"),
    ]
    @project = Generate.project :members => @users
  end
  Given "one of of those users logs in" do
    a_user_who_just_logged_in :user => @users.first
  end


  When "they navigate to the project" do
    click_project_link_for @project
  end
  Then "they will see that each user is listed in the sidebar" do
    response.should have_tag("#sidebar .people") do
      with_tag("*", "Bob Smith".to_regexp)
      with_tag("*", "Stephen Colbert".to_regexp)
      with_tag("*", "Benjamin Franklin".to_regexp)
    end
  end
end