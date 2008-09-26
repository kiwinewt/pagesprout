class AdminController < ApplicationController
  layout 'admin'
  def index
  end
  
  def users
    @users = User.find(:all)
  end
  
  def settings
    get_config
    @themes = get_themes
    @options = {}
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
  
  def save_settings
    get_config
    settings_group = params["settings"]
    settings = {}
    for param in params
      if param[0].include? settings_group
        settings[param[0].gsub(settings_group + "_", "")] = param[1]
      end
    end
    settings_dump = @application_config.marshal_dump
    for section in settings_dump.each
      if section[0].to_s == settings_group && section[1]
        for item in settings_dump[section[0]]
          if item[0].include? "theme"
            settings_dump[section[0]][item[0]] = settings[item[0]]['id']
          else
            settings_dump[section[0]][item[0]] = settings[item[0]]
          end
        end
      end
    end
    if settings_dump
      @application_config = OpenStruct.new(settings_dump)
    end
    save_config
    redirect_to :action => 'settings'
    flash[:notice] = "Settings Saved"
  end
  
  private    
    def get_themes
      result = {}
      files = Dir.entries("#{RAILS_ROOT}/public/themes/")
      for file in files.each
        file.to_s
        if !file.include? "."
          result[file] = file
        end
      end
      result.sort
    end
    
    def get_config
      @application_config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
    end
    
    def save_config
      output = "# configuration goes in here\n# this file is read as:\n#\n# any new settings added can be accessed with AppConfig.setting_name\n" + @application_config.marshal_dump.to_yaml
      config_file = File.join(RAILS_ROOT, "config/config.yml")
      File.open(config_file, 'w') { |f| f.write(output) }  
      
      new_application_config = @application_config
      env_config = new_application_config.send(RAILS_ENV)
      new_application_config.common.update(env_config) unless env_config.nil?
      #::AppConfig = OpenStruct.new(new_application_config.common)
      new_application_config.common.keys.each do |key|
        AppConfig.set_param(key,new_application_config.common[key])
      end
    end
end
