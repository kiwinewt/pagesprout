require 'test_helper'

class PasswordControllerTest < ActionController::TestCase
  def test_login_fail
    post :create, :login => "home", :password => "Tester"  
    assert @response.body.include?('<div class="flash_notice">Could not find a user with that email address.</div>')
    assert_response :success
  end
end
