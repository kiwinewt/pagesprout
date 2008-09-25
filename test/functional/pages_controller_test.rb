require 'test_helper'
require 'sessions_controller'

class PagesControllerTest < ActionController::TestCase
  fixtures :users
  
  def test_create_page
    create_session  
    assert_redirected_to( :action=>"new", :controller=>"sessions" )
  end
  
  def test_create_page_no_user
    post :create, :page => { :title => "home", :body => "Tester", :slug => "home", :home_page => false }  
    assert_redirected_to( :action=>"new", :controller=>"sessions" )
  end 
  
  def test_page_version_increase
    create_page
    :page
    assert true
  end
  
  def test_non_existant_page
    get :page => "700"
    assert_response 404
  end

  
  protected
    def create_page(options = {})
      post :create, :page => { :title => "home", :body => "Tester", :slug => "home", :home_page => false }.merge(options)
    end
    
    def create_session
      post :create, :session => { :login => "quentin", :password => "test" }
    end
    
end
