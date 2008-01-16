require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Story Tags", %|
  As a user 
  I should be able to view stories grouped by tags
  so that I can see stories in tag-based organization|, 
  :type => RailsStory do

  Scenario "viewing by tags on the stories page" do
    Given "there are no stories in the system" do
      there_are_no_stories_in_the_system
    end
    And "a user is viewing the stories page of a project" do
      a_user_viewing_the_stories_page_of_a_project
    end
    When "they click on the tag based view link" do
      click_tags_view_link 
    end
    Then "they see an empty list of stories" do
      see_empty_stories_list
    end
    
    Given "two stories are added with the tag 'foo' (2)" do
      @foo_stories = add_stories_to_the_project_with_tag("foo", :count => 2)
    end
    And "a user is viewing the stories page of a project (2)" do
      a_user_goes_to_the_stories_page_of_the_existing_project
    end
    When "they click on the tag based view link (2)" do
      click_tags_view_link
    end
    Then "they will see a foo tag header (2)" do
      see_tag_header_for "foo"
    end
    And "they will see the two stories under the foo tag header (2)" do
      see_stories_under_tag_foo
    end
    
    Given "two more stories are added with the tag 'bar' (3)" do
      @bar_stories = add_stories_to_the_project_with_tag("bar", :count => 3)
    end
    And "a user is viewing the stories page of a project (3)" do
      a_user_goes_to_the_stories_page_of_the_existing_project    
    end
    When "they click on the tag based view link (3)" do
      click_tags_view_link      
    end
    Then "they will see a bar tag header (3)" do
      see_tag_header_for "bar"
    end
    And "they will see the two new stories under the bar tag header (3)" do
      see_stories_under_tag_bar
    end
    And "they will see the foo tag header (3)" do
      see_tag_header_for "foo"
    end
    And "they will see the two original stories under foo tag header (3)" do
      see_stories_under_tag_bar
    end
  end
  
  def add_stories_to_the_project_with_tag(tag, options)
    stories = []
    options[:count].times do |i|
      stories << Generate.story(:summary => "story #{i} for tag #{tag}", :project => @project, :tag_list => tag)
    end
    stories
  end

  def a_user_goes_to_the_stories_page_of_the_existing_project
    reset!
    a_user_viewing_a_project :project => @project, :user => @user
    click_stories_link @project
  end

  def in_stories_tag_for(tag_id, &blk)
    assert_select %|#stories #tag_#{tag_id}.story_list|, &blk
  end

  def see_stories_under_tag(stories, tag_name)
    tag = Tag.find_by_name(tag_name)
    in_stories_tag_for(tag.id) do
      stories.each do |story|
        see_story_card_for(story.id)
      end      
    end
  end
  
  def see_stories_under_tag_bar
    see_stories_under_tag(@bar_stories, "bar")
  end

  def see_stories_under_tag_foo
    see_stories_under_tag(@foo_stories, "foo")
  end
  
  def see_tag_header_for(text)
    see_stories_header text
  end
  

end