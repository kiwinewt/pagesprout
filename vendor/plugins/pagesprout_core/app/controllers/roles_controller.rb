# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the users roles.
# Currently only the Administrator role is used.
class RolesController < ApplicationController
  before_filter :check_administrator_role
  
  # Index action. List all roles and those for current user.
  # Admin user only.
  def index
    @roles = Role.find(:all)
    @user = User.find(params[:user_id])
    render :action => "index", :layout => "admin"
  end
  
  # Create a new role.
  def new
    @role = Role.new
    @user = User.find(params[:user_id])
  end
  
  # Save the new role. Second half of new method.
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
  
  # Add the selected role to the user.
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
