steps_for :a_user_reordering_stories do
  Given "there is a project with stories" do
    @project = Generate.project
    @stories = Generate.stories :count => 10, :project => @project
  end
  Given "a logged in user without access to the project" do
    @user = Generate.user
    get login_path
    login_as @user.email_address, "password"
  end
  Given "a logged in user accesses the project" do
    @user = Generate.user
    @user.projects << @project
    get login_path
    login_as @user.email_address, "password"    
  end
  

  When "the user reorders the stories" do
    @reordered_ids = @stories.reverse.map(&:id)
    put reorder_stories_path(@project), :iteration_nil => @reordered_ids
  end
  
  Then "the positions of the stories are not updated" do
    @stories.each_with_index do |id, i|
      Story.find(id).position.should == i+1
    end    
  end
  
  Then "the positions of the stories are updated" do
    @reordered_ids.each_with_index do |id, i|
      Story.find(id).position.should == i+1
    end
  end
  
end
