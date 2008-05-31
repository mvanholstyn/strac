module LwtTesting
  module UserStates
    def a_user_at_the_login_page
      get login_path
    end

    def a_user_who_just_logged_in(options={})
      reset!
      @__user_count ||= 0
      options[:user] ||= Generate.user(:email_address => "joe#{@__user_count+=1}@blow.com")
      user = options[:user]

      get login_path
      login_as user.email_address, "password"
      user
    end
        
    def a_user_viewing_a_project(options={})
      reset!
      @__user_count ||= 0
      options[:project] ||= Generate.project(:name => "ProjectA")
      options[:user] ||= Generate.user(:email_address => "joe#{@__user_count+=1}@blow.com")
      @project = options[:project]
      @user = options[:user]
      @user.projects << @project
  
      get login_path
      login_as @user.email_address, "password"
      click_project_link_for @project
      @user
    end

    def a_user_viewing_the_stories_page_of_a_project
      a_user_viewing_a_project
      click_stories_link @project
    end
    
    def a_user_viewing_the_phase_list_for_a_project
      a_user_viewing_a_project
      click_phases_link_for_project(@project)
    end
    
  end
end

module Spec::Story::World
  include LwtTesting::UserStates
end