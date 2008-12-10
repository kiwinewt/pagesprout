# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class Theme
  THEME_DIRECTORY = "#{RAILS_ROOT}/public/themes/"
  
  attr_accessor :name
  
  def initialize(nm)
    @name = nm
  end
  
  def stylesheet
    "/themes/#{name}/stylesheets/master"
  end
  
  def self.active
    AppConfig.theme ? new(AppConfig.theme) : default
  end
  
  def self.admin
    new('admin')
  end
  
  def self.default
    new('default')
  end
  
  def self.all
    files = Dir.entries(THEME_DIRECTORY)
    excludes = %w{ . .. admin }
    files.delete_if do |file|
      excludes.include?(file) || !File.directory?(THEME_DIRECTORY + file)
    end
    files.collect { |t| self.new(t) }
  end
  
end
