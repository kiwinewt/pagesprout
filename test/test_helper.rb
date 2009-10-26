ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'sessions_controller'

class Test::Unit::TestCase
  include AuthenticatedTestHelper
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def no_test
    flunk "Test hasn't been written yet."
  end
  
  def user_signin
    old_controller = @controller
    @controller = SessionsController.new
    @request     = ActionController::TestRequest.new
    @response    = ActionController::TestResponse.new
    post :create, :login => 'quentin', :password => 'test'
    @controller = old_controller
  end

  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end

end
