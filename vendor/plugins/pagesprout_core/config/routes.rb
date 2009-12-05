ActionController::Routing::Routes.draw do |map|

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activation '/activate/:id', :controller => 'accounts', :action => 'show'
  map.forgot_password '/forgot_password', :controller => 'password', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'password', :action => 'edit'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'
  
  map.search '/search', :controller => 'search', :action => 'search'
  map.errorpage '/pages/errorpage', :controller => 'pages', :action => 'errorpage'
  map.sitemap 'sitemap.xml', :controller => 'pages', :action => 'sitemap'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  
  # Deprecated in favour of page_list_path
  map.page_list '/pages/list', :controller => "pages", :action => "list"
  
  # TODO make versions RESTful
  map.revert_to_version '/pages/revert_to_version/:id/:version', :controller => "pages", :action => "revert_to_version"
  map.resources :pages, :collection => { :list => :get, :published => :get, :draft => :get }, :member => { :versions => :get }
  
  map.resources :roles

  map.resources :users, :as => 'people', :member => { :enable => :put } do |users|
    users.resource :accounts
    users.resources :roles
  end

  map.resource :session
  map.resource :password
  map.admin '/admin', :controller => 'admin'
  
  # TODO turn themes into a RESTful controller
  map.themes '/design', :controller => 'admin', :action => 'theme'
  map.activate_theme '/design/:name/activate', :controller => 'admin', :action => 'save_theme'
  
  map.root :controller => 'pages'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => 'pages', :action => 'errorpage'
end
