# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :login_required
  helper :all
  include AuthenticatedSystem
  protect_from_forgery
end
