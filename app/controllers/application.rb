# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :login_required
  helper :all
  layout 'master'
  include AuthenticatedSystem
  protect_from_forgery
  # simple error handling when in production environment
  if RAILS_ENV == 'production'
    rescue_from ActionController::UnknownAction, :with => :not_found
    rescue_from NoMethodError, :with => :not_found
    rescue_from NameError, :with => :not_found
  end
  
  def not_found
    redirect_to :controller => "about", :action => 'errorpage'
  end

end
