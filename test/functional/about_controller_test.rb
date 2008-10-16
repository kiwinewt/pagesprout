require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  def test_home_page_default
    get :index
    assert_response :success
  end
  
  def test_home_page_set
    user_signin
    @page = Page.new(:title => "agnu page", :body => "A Gnu Page", :slug => "home", :enabled => 1, :home_page => 1)
    @page.save
    get :index
    assert_redirected_to :action=>"show", :controller=>"pages", :id => "home" 
  end
    
end
