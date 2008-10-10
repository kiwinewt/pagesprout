class UsersController < ApplicationController

  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :public_profile, :only => :show
  before_filter :login_required, :only => [:edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  #This show action only allows users to view their own profile
  def show
    @user = User.find(params[:id])
  end
    
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.public_profile = false
    @user.save!
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
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
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :controller => 'admin', :action => 'users'
  end
 
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
    def public_profile
      logged_in?
      @user = User.find(params[:id])
      result = @user.public_profile || authorized?
      result || permission_denied
    end

end
