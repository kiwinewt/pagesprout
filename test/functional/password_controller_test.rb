require 'test_helper'

class PasswordControllerTest < ActionController::TestCase
  test "login failure" do
    post :create, :login => "home", :password => "incorrect"
    assert_response :success # incorrect would be redirect
  end
end
