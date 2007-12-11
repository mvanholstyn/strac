def a_user_viewing_a_project(options={})
  options[:project] ||= Generate.project("ProjectA")
  options[:user] ||= Generate.user("joe@blow.com")
  @project = options[:project]
  @user = options[:user]
  @user.projects << @project
  
  get login_path
  login_as @user.email_address, "password"
  click_project_link_for @project
end
