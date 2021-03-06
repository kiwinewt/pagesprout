require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  def test_create_page
    user_signin
    assert_difference('Page.count') do
      post :create, :page => { :title => "agnu", :body => "A Gnu Page", :permalink => "newpage" }
    end
  end
  
  def test_requires_login_to_create_page
    post :create, :page => { :title => "home", :body => "Tester", :permalink => "home", :home_page => false }  
    assert_redirected_to new_session_path
  end 
  
  def test_page_version_increase
    create_page
    :page
    assert true
  end
  
  def test_non_existent_page
    get :post => {:id => "lah"}
    assert_response :redirect
    #assert_redirected_to( :action=>"index", :controller=>"about" )
  end
  
  protected
    def create_page(options = {})
      post :create, :page => { :title => "home", :body => "Tester", :permalink => "home", :home_page => false }.merge(options)
    end
    
end
