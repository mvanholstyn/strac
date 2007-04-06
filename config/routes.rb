ActionController::Routing::Routes.draw do |map|
  map.resources :tags, :collection => { :auto_complete => :any }
  map.resources :companies
  map.resources :users, :collection => { :login => :any, :logout => :post }
  map.resources :projects do |project_map|
    project_map.resources :iterations, :collection => { :current => :get }
    project_map.resources :stories,
                          :collection => { :reorder => :put },
                          :member => { :update_points => :put, :update_status => :put, :time => :any, :take => :put, :release => :put }
  end
  map.textile_preview 'textile/preview', :controller => 'textile', :action => 'preview'
  map.dashboard '', :controller => "dashboard"
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"
end
