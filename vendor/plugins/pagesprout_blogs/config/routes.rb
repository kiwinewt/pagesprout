ActionController::Routing::Routes.draw do |map|
  
  map.resources :blogs
  map.resources :blogs do |blogs|
    blogs.resources :posts, :collection => { :published => :get, :draft => :get }
  end
  
end
