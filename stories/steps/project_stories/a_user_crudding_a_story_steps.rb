steps_for :a_user_crudding_a_story do
  Given "there is a project with stories" do
    @project = Generate.project
    @stories = Generate.stories :count => 10, :project => @project
  end
  Given "a logged in user accesses the project" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"    
  end
  
  When "the user creates a story" do
    post stories_path(@project), :story => {:summary => "My Story"}
  end
  When "the user updates a story without enough information" do
    put story_path(@project, @project.stories.first), :story => { :summary => "" }
  end
  When "the user updates a story with enough information" do
    put story_path(@project, @project.stories.first), :story => { :summary => "Updated Summary", :description => "" }
    follow_redirect! while response.redirect?
  end
  
  Then "the user is notified of success" do
    response.should have_rjs(:chained_replace_html, "notice", /My Story/)
    response.should have_rjs(:hide, "error")
    response.should have_rjs(:show, "notice")
  end
  Then "the user is notified that the story was updated" do
    response.should have_tag('#notice', /Updated Summary.*updated/)
  end
  Then "the user is notified of errors" do
    see_errors "There were problems with the following fields".to_regexp
  end
  
  
  Then "the story list is updated" do
    response.should have_rjs(:insert_html, :bottom, "iteration_nil", /My Story/)
    response.should have_rjs(:chained_replace_html, "iteration_nil_story_new"){
      with_tag("input[value=?]", "My Story", false)
    }
    response.body.should match(/Strac.Iteration.drawWorkspaceVelocityMarkers/)
  end
  
  Then "the positions of the stories are updated" do
    @reordered_ids.each_with_index do |id, i|
      Story.find(id).position.should == i+1
    end
  end
  
end
