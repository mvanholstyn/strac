ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => "users" do |users_map|
    users_map.login "users/login", :action => "login"
    users_map.reminder_login "users/:id/login/:token", :action => "login"
    users_map.logout "users/logout", :action => "logout"
    users_map.reminder "users/reminder", :action => "reminder"
    users_map.profile "users/profile", :action => "profile"
    users_map.signup "users/signup", :action => "signup"
  end

  map.resources :tags, :collection => { :auto_complete => :any }
  map.resources :projects do |project_map|
    project_map.resources :phases
    project_map.resources :invitations
    project_map.resources :iterations, :name_prefix => nil, 
                          :collection => { :current => :get },
                          :member => { :stories => :get }
    project_map.resources :stories, :name_prefix => nil,
                          :collection => { :reorder => :put },
                          :member => { :update_points => :put, :update_status => :put, 
                                       :time => :any, :take => :put, :release => :put } do |story_map|
        story_map.resources :comments, :name_prefix => nil
    end
  end
  map.textile_preview 'textile/preview', :controller => 'textile', :action => 'preview'
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"

  map.root :controller => "dashboard"
  map.dashboard "", :controller => "dashboard"
end
