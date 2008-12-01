class Theme
  
  attr_accessor :name
  
  def initialize(nm)
    @name = nm
  end
  
  def self.active
    new(AppConfig.theme || "default")
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