def a_user_viewing_a_project
  @project = Generate.project("ProjectA")
  user = Generate.user("joe@blow.com")
  user.projects << @project
  
  get login_path
  login_as user.email_address, "password"
  click_project_link_for @project
end
