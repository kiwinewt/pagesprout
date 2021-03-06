# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

# This class takes care of the users, including new user activation tokens.
class UsersController < ApplicationController
  layout 'admin'
  
  # OPTIMIZE drowning in filters
  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :set_mail_url, :only => [:new, :create] 
  before_filter :public_profile, :only => :show
  before_filter :login_required, :only => [:edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  filter_parameter_logging :password
  
  # GET /users/1
  def show
    @user = User.find(params[:id])
  end
  
  # GET /users
  def index
    @users = User.all
  end
    
  # GET /users/new
  def new
    @user = User.new
  end
 
  # Create the new user, sending them to the login path after signup.
  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.public_profile = false
    @user.save!
    if @user.pending?
      flash[:notice] = "Thanks for signing up! Please log in." # TODO create session rather than force the user yet another step to log in
    else
      flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    end
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end
  
  # Edit user profile.
  def edit
    @user = User.find(params[:id])
  end
  
  # Save user profile.
  def update
    @user = User.find(params[:id])
    @user.update_attribute(:public_profile, params[:user][:public_profile])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
  
  # Disable user.
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :controller => 'admin', :action => 'users'
  end
 
  # Enable user.
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to :controller => 'admin', :action => 'users'
  end
  
  protected
    # Check if there is a logged in user, if not, find if the users profile is public.
    # If not, permission denied, redirect to homepage.
    def public_profile
      logged_in?
      @user = User.find(params[:id])
      result = @user.public_profile || authorized?
      result || permission_denied
    end

end
