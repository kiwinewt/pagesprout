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
    redirect_to :action => 'settings'
  end
  
  # Theme changing page
  def theme
    @themes = get_themes
  end
  
  #User admin page - lists all users.
  def users
    @users = User.find(:all)
  end
  
  # Settings page. Uses tables from the app_config dump
  def settings
    get_config
    @options = {}
    # convert the config to a table to be able to access it as key-value pairs
    @application_config.marshal_dump.keys.each do |group|
      group_values = @application_config.send(group.to_s)
      @options[group.to_s] = {}
      if group_values
        group_values.keys.each do |key|
          @options[group.to_s][key.to_s] = group_values[key].to_s
        end
      end
    end
  end
  
  # Save settings action. Takes all settings, merges them with existing settings.
  # After this, writes to the yaml file and updates all current settings.
  def save_settings
    get_config
    settings_group = params["settings"]
    settings = {}
    # find all the parameters that start with the settings group eg common_xxx
    for param in params
      if param[0].include? settings_group
        settings[param[0].gsub(settings_group + "_", "")] = param[1]
      end
    end
    #convert the current settings to a table then update all the originals with the new settings
    settings_dump = @application_config.marshal_dump
    for section in settings_dump.each
      if section[0].to_s == settings_group && section[1]
        for item in settings_dump[section[0]]
          if !item[0].include? "theme"
            settings_dump[section[0]][item[0]] = settings[item[0]]
          end
        end
      end
      # find any new fields and add them to the settings
      for item in params.each
        theLabel = section[0].to_s+"_new_label_"
        if item[0].include? theLabel
          count = item[0].gsub(theLabel,"")
          theField = params[item[0]]
          theValue = params[section[0].to_s+"_new_value_"+count]
          if settings_dump[section[0]] != nil
            settings_dump[section[0]].merge!({theField => theValue})
          else
            settings_dump.merge!({section[0] => {theField => theValue}})
          end
        end
      end
    end
    # if there are new settings then save them. helps stop all settings being wiped
    if settings_dump
      @application_config = OpenStruct.new(settings_dump)
    end
    save_config
    redirect_to :action => 'settings'
    flash[:notice] = "Settings Saved"
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
      output = "# configuration goes in here\n# this file is read as:\n#\n# any new settings added can be accessed with AppConfig.setting_name\n" + @application_config.marshal_dump.to_yaml
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
