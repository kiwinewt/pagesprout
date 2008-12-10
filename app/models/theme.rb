# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class Theme
  PUBLIC_THEME_DIRECTORY = '/themes/'
  THEME_DIRECTORY = File.join('public', PUBLIC_THEME_DIRECTORY)
  
  attr_accessor :name
  
  def initialize(nm)
    @name = nm
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
