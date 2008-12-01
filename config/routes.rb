ActionController::Routing::Routes.draw do |map|

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'password', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'password', :action => 'edit'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'
  
  map.search '/search', :controller => 'search', :action => 'search'
  map.sitemap 'sitemap.xml', :controller => 'pages', :action => 'sitemap'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  
  map.page_list '/pages/list', :controller => "pages", :action => "list"
  map.revert_to_version '/pages/revert_to_version/:id/:version', :controller => "pages", :action => "revert_to_version"
  map.resources :pages
  
  map.resources :roles

  map.resources :users, :member => { :enable => :put } do |users|
    users.resource :accounts
    users.resources :roles
  end
  
  map.resources :blogs
  map.resources :blogs do |blogs|
    blogs.resources :posts
  end

  map.resource :session
  map.resource :password
  map.admin '/admin', :controller => 'admin'
  
  map.root :controller => 'pages'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => 'pages', :action => 'errorpage'
end
