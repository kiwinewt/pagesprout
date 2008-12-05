# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class Theme
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
    # TODO simplify
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
  
end
