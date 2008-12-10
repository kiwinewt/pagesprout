# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the Admin Section
class AdminController < ApplicationController
  layout 'admin'
  before_filter :check_administrator_role
  
  # Redirect to the settings page as there is nothing on this page.
  # Change this method to allow items to be placed specifically on the main admin page.
  def index
  end
  
  # Theme changing page
  def theme
    @themes = Theme.all
  end
  
  #User admin page - lists all users.
  def users
    @users = User.find(:all)
  end
  
  # Save theme action. Updates the theme in the app_config settings and yaml file.
  # TODO move to themes controller, make RESTful
  def save_theme
    theme = Theme.new(params[:name])
    if theme.active?
      flash[:notice] = 'That theme is already active.'
    else
      theme.activate!
      flash[:success] = 'Theme changed.'
    end
    redirect_to :action => 'theme'
  end
end
