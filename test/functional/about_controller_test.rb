require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  test "get index" do
    get :index
    assert_response :success
  end
  
  # This should be in PageControllerTest
  test "set home page" do
    user_signin
    page = Page.new(:title => "agnu page", :body => "A Gnu Page", :slug => "home", :enabled => 1, :home_page => 1)
    page.save
    get :index
    assert_redirected_to :action=>"show", :controller=>"pages", :id => "home" 
  end
  
  test "get empty search" do
    get :search
  end
    
end
