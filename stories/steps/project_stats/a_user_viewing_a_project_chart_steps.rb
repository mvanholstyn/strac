steps_for :a_user_viewing_a_project_chart do
  Given "there is a project with no estimated stories" do
    @project = Generate.project
    10.times do 
      @project.stories << Generate.story
    end
  end
  Given "there is a project with estimated stories" do
    @project = Generate.project
    10.times do 
      @project.stories << Generate.story(:points => 2, :project => @project)
    end    
  end

  
  When "a user views the project" do
    a_user_viewing_a_project :project => @project    
  end
  
  Then "won't see a project burndown chart" do
    response.should_not have_tag("img[src=?]", chart_project_path(@project))
  end
  Then "see a project burndown chart" do
    response.should have_tag("img[src=?]", chart_project_path(@project))
  end
  
end