ActionController::Routing::Routes.draw do |map|

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'password', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'password', :action => 'edit'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'
  
  map.resources :pages, :collection => { :completely_destroy_deleted => :delete }, :member => { :restore => :put, :completely_destroy => :delete }
  map.revert_to_version '/pages/revert_to_version/:id/:version', :controller => "pages", :action => "revert_to_version"
  
  map.resources :roles

  map.resources :users, :member => { :enable => :put } do |users|
    users.resource :accounts
    users.resources :roles
  end

  map.resource :session
  map.resource :password
  map.admin '/admin', :controller => 'admin'
  
  map.root :controller => 'about'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => 'about', :action => 'errorpage'
end
