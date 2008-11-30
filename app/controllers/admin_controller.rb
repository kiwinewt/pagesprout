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
    redirect_to pages_path
  end
  
  # Theme changing page
  def theme
    @themes = get_themes
  end
  
  #User admin page - lists all users.
  def users
    @users = User.find(:all)
  end
  
  # Save theme action. Updates the theme in the app_config settings and yaml file.
  def save_theme
    get_config
    theValue = params['theme']
    settings_dump = @application_config.marshal_dump
    settings_dump[:common].merge!({"theme" => theValue})
    if settings_dump
      @application_config = OpenStruct.new(settings_dump)
    end
    save_config
    redirect_to :action => 'theme'
    flash[:notice] = "Theme changed"
  end
  
  private
    # Return a list of themes based on directory names.
    def get_themes
      result = {}
      files = Dir.entries("#{RAILS_ROOT}/public/themes/")
      files.each do |file|
        file.to_s
        if !file.include? "."
          result[file] = file
        end
      end
      result.sort
    end
    
    # Load the config file into an openstruct.
    def get_config
      @application_config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
    end
    
    # Save the app_config settings into the yaml file.
    def save_config
      output = "# Settings are accessed with AppConfig.setting_name\n" + @application_config.marshal_dump.to_yaml
      config_file = File.join(RAILS_ROOT, "config/config.yml")
      File.open(config_file, 'w') { |f| f.write(output) }  
      
      # for this to work without having to restart the RoR server the AppConfig
      # plugin had to be modified to be able to save the variables
      new_application_config = @application_config
      env_config = new_application_config.send(RAILS_ENV)
      new_application_config.common.update(env_config) unless env_config.nil?
      new_application_config.common.keys.each do |key|
        AppConfig.set_param(key,new_application_config.common[key])
      end
    end
end
