steps_for :a_user_starting_an_iteration do
  Given "there is a project with incomplete stories and zero iterations" do
    @project = Generate.project :iterations => []
    @stories = Generate.stories :count => 10, :project => @project, :status => Status.defined
  end
  Given "a logged in user accesses the project's workspace page" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"
    click_project_link_for(@project)
    click_workspace_link(@project)
  end
  Given "there is a project with a current iteration" do
    @project = Generate.project :iterations => []
    @stories = Generate.stories :count => 10, :project => @project, :status => Status.defined
    @iteration = Generate.iteration :project => @project, :start_date => 1.week.ago.to_date
  end
  
  
  When "they click on the start iteration link" do
    click_link project_iterations_path(@project)
  end
  
    
  Then "they will see that the current iteration started today" do
    response.should have_tag(".current_iteration_started_on", Date.today.strftime("%m-%d-%Y").to_regexp)
  end
  Then "they will see an error telling them they have to wait until tomorrow to do that" do
    response.should have_tag('#error', "You'll have to wait for two days to start another iteration.".to_regexp)
  end
  Then "the previous iteration will have been updated to have ended yesterday" do
    @iteration.reload.end_date.should == Date.yesterday
  end
end