require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test "requires admin" do
    user_signin
    get :index
    assert_response :success
  end
  
  test "no admin new session" do
    get :index
    assert_redirected_to new_session_path
  end
end
