steps_for :a_user_starting_an_iteration do
  Given "there is a project with incomplete, but estimated stories and no iterations" do
    @project = Generate.project :iterations => []
    @stories = Generate.stories :count => 5, :project => @project, :status => Status.defined
    @stories.each_with_index do |story, i|
      story.update_attribute(:points, i)
    end
    @complete_stories = []
    @incomplete_stories = @stories
  end
  Given "a logged in user accesses the project's workspace page" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"
    click_project_link_for(@project)
    click_workspace_link(@project)
  end
  Given "there is a project with a current iteration that has incomplete and complete stories" do
    @project = Generate.project :iterations => []
    @iteration = Generate.iteration :project => @project, :start_date => 1.week.ago.to_date
    @complete_stories = Generate.stories :count => 5, :project => @project, :status => Status.complete, :bucket => @iteration
    @incomplete_stories = Generate.stories :count => 5, :project => @project, :status => Status.defined, :bucket => @iteration
    (@complete_stories + @incomplete_stories).each_with_index do |story, i|
      story.update_attribute(:points, i)
    end
    @stories = @complete_stories + @incomplete_stories
  end
  
  
  When "they click on the start iteration link" do
    click_link project_iterations_path(@project)
    @current_iteration = @project.iterations.current
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
  Then "the current iteration will create a snapshot of the total number of points for the project" do
    @current_iteration.snapshot.total_points.should == @project.total_points
  end
  Then "the current iteration will create a snapshot of the total number of completed points for the project" do
    @current_iteration.snapshot.completed_points.should == @project.completed_points
  end
  Then "the current iteration will create a snapshot of the total number of remaining points for the project" do
    @current_iteration.snapshot.remaining_points.should == @project.remaining_points
  end
  Then "the current iteration will create a snapshot of the average velocity for the project" do
    @current_iteration.snapshot.average_velocity.should == @project.average_velocity
  end
  Then "the current iteration will create a snapshot of the estimated remaining iterations" do
    @current_iteration.snapshot.estimated_remaining_iterations.should == @current_iteration.project.estimated_remaining_iterations
  end
  Then "the current iteration will create a snapshot of the estimated completion date" do
    @current_iteration.snapshot.estimated_completion_date.to_s.should == @current_iteration.project.estimated_completion_date.to_s
  end
  
end