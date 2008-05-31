steps_for :a_user_commenting_a_story do
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
  

  When "the user creates a comment for a story" do
    @story = @project.stories.first
    xml_http_request :get, new_comment_path(@story.project, @story), '_method' => 'get'
    response.should have_rjs(:replace_html, "story_#{@story.id}_new_comment") do
      with_tag('form#comment_form')
    end
    
    xml_http_request :post, comments_path(@story.project, @story), 'comment' => { 'content' => "Abracadabra" }
  end

  Then "they see the comment added to the story" do
    response.should have_rjs(:insert, :bottom, "story_#{@story.id}_comments_list") do
      with_tag('.comment', /Abracadabra/ )
    end
    Story.find(@story.id).comments.first.content.should == "Abracadabra"    
  end
end
