require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Phases", %|
  As a user 
  I should be able to create and assign stories to phases 
  so that I can manage a wishlist of features for the future.|, 
  :type => RailsStory do

  Scenario "viewing an empty phases list" do
    Given "a user is viewing a project" do
      a_user_viewing_a_project
    end
    When "they click on the phases link" do
      click_project_phases_link_for(@project)
    end
    Then "they will see an empty phases list" do
      see_empty_project_phases_list
    end
  end
  
  Scenario "creating a phase" do
    Given "a user is viewing the phases list" do
      a_user_viewing_a_projects_phase_list
    end
    When  "they click on the create phase link" do
      click_create_phase_link
    end
    Then "they will be presented with the create a phase form" do
      see_new_project_phase_form
    end
      
    Given "a user is viewing the create a phase form" do
      see_new_project_phase_form
    end
    When "they submit the create a phase form with invalid information" do
      submit_create_project_phase_form_with_invalid_information
    end
    Then "they will see project phase errors" do
      see_create_project_phase_errors
    end

    Given "a user is viewing the create a phase form (2)" do
      see_new_project_phase_form
    end
    When "they submit the create a phase form with valid information" do
      submit_create_project_phase_form_with_valid_information
    end
    Then "they will see the newly created phase" do
      see_newly_created_project_phase
    end
  end
  
  Scenario "viewing an individual phase that has no stories" do
    Given "a phase exists in the system" do
      @phase = Generate.phase "Phazaloopa", :description => "El Phazaloopa"
    end
    And "a user is viewing the phases list (2)" do
      a_user_viewing_a_project(:project => @phase.project)
      click_project_phases_link_for(@phase.project)
    end
    When "they click on the phase's link" do
      click_project_phase_link_for(@phase.project, @phase)
    end
    Then "they will see the phase's name" do
      see_project_phase_name(@phase.name)
    end
    And "they will see the phases's description" do
      see_project_phase_description(@phase.description)
    end
    And "they will see an empty stories list" do
      see_empty_project_phase_stories_list
    end
  end
  
  Scenario "adding a story to a phase" do
    Given "a phase with no stories exists in the system" do
      @phase = Generate.phase "Phazaloopa", :description => "El Phazaloopa"
      @phase.stories.should be_empty
    end
    And "a story exists in the system" do
      @story = Generate.story :summary => "some story", :project => @phase.project
    end
    And "a user is editing the story" do
      a_user_viewing_a_project(:project => @phase.project)
      go_to_edit_story(@story.project, @story)
    end
    When "they change the story to belong to the phase and submit the form" do
      submit_form 'edit_form' do |form|
        form.story.bucket_id = @phase.id.to_s
      end
    end
    Then "they see the story show page" do
      response.should redirect_to(story_path(@story.project, @story))
      follow_redirect! while response.redirect?
    end
    
    Given "a user is viewing the phases list (3)" do
      go_to_project_phases(@phase.project)
      click_project_phases_link_for(@phase.project)
    end
    When "they click on the phase's link (3)" do
      click_project_phase_link_for(@phase.project, @phase)
    end
    Then "they will see the story in the stories list" do
      see_story @story
    end
  end
  
  Scenario "how the project summary is affected by adding a story to a phase" do
    Given "a completed story exists that does not belong to a phase" do
      @phase = Generate.phase "Another Day Another Phase", :description => "woohah"
      @story = Generate.story :summary => "story1", :project => @phase.project, :points => 10, :status => Status.complete
    end
    And "a user viewing a project (4)" do
      a_user_viewing_a_project(:project => @phase.project)
      @total_points = grab_project_summary(".total_points").to_i
      @completed_points = grab_project_summary(".completed_points").to_i
    end
    When "they move the completed story to a phase" do
      move_story_to_phase(@story, @phase)
    end
    Then "they will see the points for that story are removed from the total points and completed points" do
      updated_total_points = grab_project_summary(".total_points").to_i
      updated_total_points.should == @total_points - @story.points
      updated_completed_points = grab_project_summary(".completed_points").to_i
      updated_completed_points.should == @completed_points - @story.points
    end
    
    Given "an incomplete story exists that has been estimated" do
      reset!
      @phase = Generate.phase "Another Day Another Phase", :description => "woohah"
      @story = Generate.story :summary => "story1", :project => @phase.project, :points => 10
    end
    And "a user viewing a project (5)" do
      a_user_viewing_a_project(:project => @phase.project)
      @total_points = grab_project_summary(".total_points").to_i
      @remaining_points = grab_project_summary(".remaining_points").to_i
    end
    When "they move the incomplete story to a phase" do
      move_story_to_phase(@story, @phase)
    end
    Then "they will see the points for that story are removed from the total points and completed points" do
      updated_total_points = grab_project_summary(".total_points").to_i
      updated_total_points.should == @total_points - @story.points
      updated_remaining_points = grab_project_summary(".remaining_points").to_i
      updated_remaining_points.should == @remaining_points - @story.points 
    end
  end
  
  def a_user_viewing_a_projects_phase_list
    a_user_viewing_a_project
    click_project_phases_link_for(@project)
  end
  
  def click_create_phase_link
    click_link(new_project_phase_path(@project))
  end
  
  def grab_project_summary(selector)
    assert_select(".project_summary #{selector}").first.children.to_s
  end
  
  def move_story_to_phase(story, phase)
    go_to_edit_story(story.project, story)
    submit_form 'edit_form' do |form|
      form.story.bucket_id = phase.id.to_s
    end
    follow_redirect! while response.redirect?
  end
  
  def see_story(story)
    response.should have_tag('.phase .stories #story_' + story.id.to_s)
  end
  
  def see_empty_project_phases_list
    response.should have_tag("table tr.phase", 0)
  end
  
  def see_new_project_phase_form
    response.should have_tag('form#new_phase')
  end
  
  def see_create_project_phase_errors
    response.should have_tag('#errorExplanation')
  end
  
  def see_empty_project_phase_stories_list
    response.should have_tag('.phase .stories:empty')
  end
  
  def see_newly_created_project_phase
    see_project_phase_name "FooBaz"
    see_project_phase_description "Descriptisio"
  end
  
  def see_project_phase_name(name=nil)
    name ||= @project.name
    response.should have_text(name.to_regexp)
  end
  
  def see_project_phase_description(description=nil)
    description ||= @project.description
    response.should have_text(description.to_regexp)
  end
  
  def submit_create_project_phase_form_with_invalid_information
    submit_form 'new_phase'
  end
  
  def submit_create_project_phase_form_with_valid_information
    submit_form 'new_phase' do |form|
      form.phase.name = "FooBaz"
      form.phase.description = "Descriptisio"
    end
    follow_redirect! while response.redirect?
  end
end