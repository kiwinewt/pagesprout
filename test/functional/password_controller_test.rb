require 'test_helper'

class PasswordControllerTest < ActionController::TestCase
  def test_login_fail
    post :create, :login => "home", :password => "Tester"  
    #assert @response.body.include?('flash_notice')
    assert_response :success
  end
end
