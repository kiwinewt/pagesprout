# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

class Theme
  PUBLIC_THEME_DIRECTORY = '/themes/'
  THEME_DIRECTORY = File.join('public', PUBLIC_THEME_DIRECTORY)
  
  attr_accessor :name
  
  def initialize(nm)
    @name = nm
  end
  
  def active?
    self.name == self.class.active.name
  end
  
  def stylesheet_path
    pubilc_file 'stylesheets/master.css'
  end
  
  def screenshot_path
     pubilc_file 'screenshot.jpg'
  end
  
  # Returns a filename relative to the theme directory
  def pubilc_file(filename)
    File.join(PUBLIC_THEME_DIRECTORY, name, filename)
  end
  
  def activate!
    # OPTIMIZE AppConfig
    application_config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
    settings_dump = application_config.marshal_dump
    settings_dump[:common].merge!({ "theme" => name })
    if settings_dump
      application_config = OpenStruct.new(settings_dump)
    end  
    output = "# Settings are accessed with AppConfig.setting_name\n" + application_config.marshal_dump.to_yaml
    config_file = File.join(RAILS_ROOT, "config/config.yml")
    File.open(config_file, 'w') { |f| f.write(output) }  
    
    # for this to work without having to restart the RoR server the AppConfig
    # plugin had to be modified to be able to save the variables
    new_application_config = application_config
    new_application_config.common.keys.each do |key|
      AppConfig.set_param(key,new_application_config.common[key])
    end
  end
  
  # Returns the active theme
  def self.active
    AppConfig.theme ? new(AppConfig.theme) : default
  end
  
  def self.admin
    new 'admin'
  end
  
  def self.default
    new 'default'
  end
  
  def self.all
    files = Dir.entries(THEME_DIRECTORY)
    excludes = %w{ . .. admin }
    files.delete_if do |file|
      excludes.include?(file) || !File.directory?(THEME_DIRECTORY + file)
    end
    files.collect { |t| new(t) }
  end
  
end
