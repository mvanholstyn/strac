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

def a_user_viewing_the_stories_page_of_a_project
  a_user_viewing_a_project
  click_stories_link @project
end
