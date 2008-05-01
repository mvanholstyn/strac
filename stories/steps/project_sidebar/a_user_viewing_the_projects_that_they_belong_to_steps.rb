steps_for :a_user_viewing_the_projects_that_they_belong_to do
  Given "a user without any projects logs in" do
    @user = a_user_who_just_logged_in
  end
  Given "a user who belongs to some projects logs in" do
    @user = Generate.user
    @projects = [
      Generate.project(:name => "ProjectBaz", :members => [@user]),
      Generate.project(:name => "ProjectFoo", :members => [@user])
    ]
    a_user_who_just_logged_in :user => @user
  end


  When "they look at the sidebar" do
    response.should have_tag('#sidebar')
  end


  Then "they will see no projects that they belong to in the sidebar" do
    response.should have_tag('#sidebar .your_projects:empty')
  end
  Then "they will see that they projects that they belong to in the sidebar" do
    response.should have_tag('#sidebar .your_projects') do
      @projects.each do |project|
        see_link_to_project project
      end
    end
  end
  
end