class RolesController < ApplicationController
  before_filter :check_administrator_role
  def index
    @roles = Role.find(:all)#
    @user = User.find(params[:user_id])
  end
  
  def new
    @role = Role.new
    @user = User.find(params[:user_id])
  end
  
  def create
    @role = Role.new(params[:role])
    @user = User.find(params[:user_id])

    if @role.save
      flash[:notice] = 'Role was successfully created.'
    end
    unless @user.has_role?(@role.rolename)
      @user.roles << @role
    end
    redirect_to user_roles_path(@user)
  end
  
  def update
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    unless @user.has_role?(@role.rolename)
      @user.roles << @role
    end
    redirect_to user_roles_path(@user)
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    if @user.has_role?(@role.rolename)
      @user.roles.delete(@role)
    end
    redirect_to user_roles_path(@user)
  end
end
