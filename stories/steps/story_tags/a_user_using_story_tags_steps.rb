steps_for :a_user_using_story_tags do
  Given "there are no stories in the system" do
    there_are_no_stories_in_the_system
  end
  Given "a user goes to the stories page of a project" do
    a_user_viewing_the_stories_page_of_a_project
  end
  Given "the user goes to the stories page of the project" do
    a_user_viewing_a_project :project => @project, :user => @user
    click_stories_link @project
  end
  Given "two stories are added with the tag 'foo'" do
    tag = "foo"
    @foo_stories = []
    2.times do |i|
      @foo_stories << Generate.story(:summary => "story #{i} for tag #{tag}", :project => @project, :tag_list => tag)
    end
  end
  Given "two more stories are added with the tag 'bar'" do
    tag = "bar"
    @bar_stories = []
    2.times do |i|
      @bar_stories << Generate.story(:summary => "story #{i} for tag #{tag}", :project => @project, :tag_list => tag)
    end
  end


  When "they click on the tag based view link" do
    click_tags_view_link 
  end


  Then "they see an empty list of stories" do
    see_empty_stories_list
  end  
  Then /they will see the (\w+) tag header/ do |tag|
    see_tag_header_for tag
  end
  Then "they will see the two stories under the foo tag header" do
    see_stories_under_tag(@foo_stories, "foo")
  end  
  Then "they will see the two new stories under the bar tag header" do
    see_stories_under_tag(@bar_stories, "bar")
  end
end