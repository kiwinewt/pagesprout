require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  def test_require_admin
    user_signin
    get :index  
    assert_redirected_to( :action=>"settings" )
  end
  
  def test_no_admin_new_session
    get :index
    assert_redirected_to( :action=>"new", :controller=>"sessions" )
  end
end
