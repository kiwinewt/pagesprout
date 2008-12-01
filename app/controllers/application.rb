# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all
  
  layout 'master'
  
  protect_from_forgery
  
  before_filter :login_required
  
  # simple error handling when in production environment
  if RAILS_ENV == 'development'
    rescue_from ActionController::UnknownAction, :with => :not_found
    rescue_from NoMethodError, :with => :not_found
    rescue_from NameError, :with => :not_found
  end
  
  protected
  
  # Handle the not_found action which occurs when an Exception happens.
  # Modify this for emailing exception notices.
  def not_found
    redirect_to :controller => "about", :action => 'errorpage'
  end
  
  def set_mail_url
    UserMailer.default_url_options[:host] = request.host_with_port
  end

end
