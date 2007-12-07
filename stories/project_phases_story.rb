require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project phases", %|
  As a user 
  I should be able to create and "assign stories to phases 
  so I can manage a wishlist of features for the future.
|, :type => RailsStory do
  
  Scenario "adding a phase" do
    Given "that a user is viewing a project" do
      a_user_viewing_a_project
    end
    When "they click on Phases" do
      click_link project_phases_path(@project)
    end
    Then "they will see the Phases list" do
      see_the_project_phases_list
    end
    And "they will see no phases listed" do
      see_no_project_phases
    end

    Given "that a user is viewing the Phases list"
    When "they submit the create a phase form with invalid information"
    Then "they will see errors about the invalid information"
    And "they will remain on the phases list page"

    Given "that a user is viewing the Phases list"
    When "they submit the create a phase form with valid information"
    Then "they will see a message telling me a phase has been created"
    And "they will see the phase added to the phases list"
    And "they will remain on the phases list page"
  end
  
  Scenario "adding story's to a phase" do
    Given "that a user is viewing the Phases list"
    When "they click on a phase"
    Then "they will see the individual phase page"
    And "they will see an empty story list"

    Given "that a user is viewing an individual phase page"
    When "they submit the create a story form with invalid information"
    Then "they will see errors about the invalid information"
    And "they will remain on the phase page"

    Given "that a user is viewing an individual phase page"
    When "they submit the create a story form with valid information"
    Then "they will see the story added to the story list"
    And "they will remain on the phase page"

    Given "that a user is editing a story on the stories page"
    And "add the story to a phase"
    When "they submit the form"
    Then "they will see the story removed from the current story list"
    And "they will remain on the stories page"
  end

  #
  # HELPERS
  #
    
  def see_the_project_phases_list
    response.should have_tag('#phases')
  end

  def see_no_project_phases
    response.should_not have_tag("#phases .phase")
  end

end