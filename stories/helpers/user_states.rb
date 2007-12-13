def a_user_viewing_a_project(options={})
  @__user_count ||= 0
  options[:project] ||= Generate.project("ProjectA")
  options[:user] ||= Generate.user("joe#{@__user_count+=1}@blow.com")
  @project = options[:project]
  @user = options[:user]
  @user.projects << @project
  
  get login_path
  login_as @user.email_address, "password"
  click_project_link_for @project
end
