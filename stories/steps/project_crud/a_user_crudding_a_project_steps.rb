steps_for :a_user_crudding_a_project_steps do
  Given "there are no projects in the system" do
    Project.destroy_all
  end
  Given "a logged in user" do
    @user = a_user_who_just_logged_in
  end
  
  When "they try to view a project they don't have permission to access" do
    project = Generate.project
    get project_path(project)
  end
  When "they try to edit a project they don't have permission to access" do
    project = Generate.project
    get edit_project_path(project)
  end
  When "they try to destroy a project they don't have permission to access" do
    project = Generate.project
    delete project_path(project)
  end
  When "they try to update a project they don't have permission to access" do
    project = Generate.project
    put project_path(project)
  end
  When "they try to view a project's workspace they don't have permission to access" do
    project = Generate.project
    get workspace_project_path(project)    
  end
  When "they click the projects link" do
    click_projects_link
  end
  When "they click on the new project link" do
    click_new_project_link
  end
  When "they submit the new project form without any information" do
    submit_new_project_form do |form|
      form.project.name = ""
    end
  end
  When "they submit the new project form with the required information" do
    submit_new_project_form do |form|
      form.project.name = "ProjectX"
    end
    @project = Project.find_by_name "ProjectX"
  end
  When "they click on the edit link for the newly created project" do
    click_edit_project_link @project
  end
  When "they submit the edit project form without any information" do
    submit_project_form(@project) do |form|
      form.project.name = ""
    end
  end
  When "they submit the project form with an updated name" do
    submit_project_form(@project) do |form|
      form.project.name = "Project 86"
    end
    @project = Project.find_by_name "Project 86"
  end
  When "they click the dashboard link" do
    click_dashboard_link
  end
  When "they click on the link to the project" do
    click_project_link_for(@project)
  end
  When "they click on the link to destroy the project" do
    click_destroy_project_link @project
  end
  
  Then "they will see an error telling them they can't access the resource" do
    response.should redirect_to("/access_denied.html")
  end
  Then "they will see an empty projects list" do
    response.should_not have_tag('.projects .project')
  end
  Then "they will see an error stating that the project name is required" do
    see_an_error_explanation do |error|
      error.should exist_for("name", "can't be blank")
    end
  end
  Then "they will see a message telling them the project was successfully created" do
    see_message "Project was successfully created."
  end
  Then "they will see the project" do
    response.should have_text(@project.reload.name.to_regexp)
  end
  Then "they will see the project in the project list" do
    response.should have_tag('.projects .project .name', @project.name.to_regexp)
  end
  Then "they will see the edit project form" do
    response.should have_tag('form[id=?]', dom_id(@project, 'edit'))
  end
  Then "they will see a link to the project" do
    see_link_to_project @project
  end
  Then "they will see a link to destroy the project" do
    see_link_to_destroy_project @project
  end
  Then "they will see the projects list" do
    response.should have_tag('.projects')
  end
  Then "they will not see the destroyed project in the projects list" do
    response.should_not have_tag('.projects .project .name', @project.name.to_regexp)
  end

end