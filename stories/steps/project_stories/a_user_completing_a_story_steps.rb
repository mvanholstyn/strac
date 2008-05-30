steps_for :a_user_completing_a_story do
  Given "there is a project with a running iteration and incomplete stories" do
    @project = Generate.project
    @iteration = Generate.iteration :started_at => Date.yesterday, :ended_at => nil, :project => @project
    @stories = Generate.stories :count => 10, :project => @project, :status => Status.defined
  end
  Given "a logged in user accesses the project" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"    
  end
  

  When "they update the status of the story to complete" do
    @completed_story = @stories.first
    put update_status_story_path(@project, @stories.first), :story => { :status_id => Status.complete.id }
    @completed_story.reload
  end


  Then "the story will be marked as completed" do
    @completed_story.status.should == Status.complete
  end
  Then "the story will belong to the currently running iteration" do
    @completed_story.bucket.should == @iteration
  end
end
