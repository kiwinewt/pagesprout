# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]

  # render new.rhtml
  def new
  end

  # login
  def create
    reset_session
    password_authentication(params[:login], params[:password])
  end

  # logout
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_path    
  end
  
  protected

    # Login action, check the user/password.
    def password_authentication(login, password)
      user = User.authenticate(login, password)
      if user == nil
        failed_login("Your username or password is incorrect.")
      elsif user.activated_at.blank?  
        failed_login("Your account is not active, please check your email for the activation code.")
      elsif user.enabled == false
        failed_login("Your account has been disabled.")
      else
        self.current_user = user
        successful_login
      end
    end

  private
    # Handle a failed login
    def failed_login(message)
      flash.now[:error] = message
      render :action => 'new'
    end
    
    # Successful login, create new session cookie.
    def successful_login
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
        flash[:notice] = "Logged in successfully"
        return_to = session[:return_to]
        if return_to.nil?
          redirect_to user_path(self.current_user)
        else
          redirect_to return_to
        end
    end
    
end
