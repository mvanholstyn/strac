ActionController::Routing::Routes.draw do |map|
  map.resources :tags, :collection => { :auto_complete => :any }

  
  map.resources :companies

  map.resources :users, :collection => { :login => :any, :logout => :post }

  map.resources :projects do |project_map|
    project_map.resources :iterations, :collection => { :current => :get }

    project_map.resources :stories,
                          :collection => { :reorder => :put },
                          :member => { :update_points => :put, :update_complete => :put }

  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # map.resources :products

  # Sample resource route with options:
  # map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.dashboard '', :controller => "dashboard"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller/:action/:id'
end
