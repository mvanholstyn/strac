steps_for :project_phases do
  Given "a user is viewing a project's phases list" do
    a_user_viewing_the_phase_list_for_a_project
  end  
  Given "a phase with no stories exists in the system" do
    @phase = Generate.phase :name => "Phazaloopa", :description => "El Phazaloopa"
    @phase.stories.should be_empty    
  end
  Given "a story exists in the system for the same project" do
    @story = Generate.story :summary => "some story", :project => @phase.project
  end
  Given "a user is editing the story" do
    a_user_viewing_a_project(:project => @phase.project)
    go_to_edit_story(@story.project, @story)
  end
    
  When "they click on the phases link" do
    click_phases_link_for_project(@project)
  end
  When "they click on the phase's link" do
    click_phase_link(@phase)
  end
  When  "they click on the create phase link" do
    click_create_phase_link_for_project @project
  end
  When "they submit the create a phase form with invalid information" do
    submit_new_phase_form_with_invalid_information
  end
  When "they submit the create a phase form with valid information" do
    submit_new_phase_form
  end
  When "a user goes to that phase" do
    a_user_viewing_a_project(:project => @phase.project)
    click_phases_link_for_project(@phase.project)    
    click_phase_link(@phase)
  end
  When "they update the story to belong to the phase" do
    submit_edit_phase_form do |form|
      form.story.bucket_id = @phase.id.to_s
    end
  end
  
  Then "they will see an empty phases list" do
    see_empty_project_phases_list
  end
  Then "they will be presented with the create a phase form" do
    see_new_project_phase_form
  end
  Then "they will see project phase errors" do
    see_create_project_phase_errors
  end
  Then "they will see the newly created phase" do
    see_newly_created_project_phase
  end
  Then "they will see the phase's name" do
    see_project_phase_name(@phase.name)
  end
  Then "they will see the phase's description" do
    see_project_phase_description(@phase.description)
  end
  Then "they will see an empty stories list" do
    see_empty_project_phase_stories_list
  end
  Then "they still see the create a phase form" do
    see_new_project_phase_form
  end
  Then "they will see the story in the stories list" do
    see_story_in_stories_list_for_phase @story
  end  
end
  
