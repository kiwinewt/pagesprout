require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  def test_home_page_default
    get :index
    assert_response :success
  end
  
  def test_home_page_set
    page = Page.create(:title => "home", :body => "Tester", :slug => "home", :home_page => true)
    page.save
    get :index
    assert_response :redirect
  end
    
end
