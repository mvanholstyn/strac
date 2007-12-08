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

    Given "that a user is viewing the Phases list (1)" do
      get project_phases_path(@project)
    end
    When "they click the create phase link" do
      click_link "create phase"
    end
    Then "they will see the create a phase form" do
      see_create_project_phase_form
    end
    
    Given "a user is viewing the create a phase form" do
      # already here
    end
    When "they submit the create a phase form with invalid information" do
      submit_create_phase_form_with_invalid_information
    end
    Then "they will see form errors" do
      response.should have_rjs(:chained_replace_html, :error)
    end

    Given "that a user is viewing the create phase form on the Phases list" do
      get project_phases_path(@project)
      click_link "create phase"
    end
    When "they submit the create a phase form with valid information" do
      submit_create_phase_form_with_valid_information
    end
    Then "they will see a message telling me a phase has been created" do
      response.should have_rjs(:chained_replace_html, :notice)
    end
    And "they will see the phase added to the phases list" do
      # TODO -- seleniumize this test
    end
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

  def see_create_project_phase_form
    response.should have_tag('form#phase_form')
  end
  
  def submit_create_phase_form_with_invalid_information
    submit_form "phase_form" do |form|
      form.phase.name = ""
    end
    response.success?.should == true
  end

  def submit_create_phase_form_with_valid_information
    submit_form "phase_form" do |form|
      form.phase.name = "Foo"
    end
    response.success?.should == true
  end

  def click_link(text, select = 'a')
    anchors = css_select("#{select}[href=#{text}]")
    if anchors.any?
      link = anchors.first
    elsif %w{# .}.include? text.first
      link = assert_select("#{select}#{text}", 1).first
    else
      link = assert_select(select,/#{text}/).first
    end
    assert_not_nil link, "link not found to click with contents: #{text}"
    path = link['href']
    assert_not_nil path, "Could not find URL for link with contents: #{text}"
    # Handling for DELETE and PUT links
    if link['onclick'] =~ /.*method = '(\w+)'.*m.setAttribute\('name', '_method'\).*m.setAttribute\('value', '(\w+)'\)/
      form_method = $1
      http_method = $2
      send form_method.downcase, link['href'], '_method' => http_method
      follow_redirect! and return
    elsif link['onclick'] =~ /Ajax\.Request\('(.*?)',/
      path = $1
    elsif link['onclick'] =~ /Ajax\.Updater\('[^']*', '(.*?)',/
      path = $1
    end

    get path    
  end

end