require 'test_helper'

class PasswordControllerTest < ActionController::TestCase
  def test_should_redirect
    get :forgot_password
    assert_response :redirect
  end
end
