# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'plugins/app_config/lib/configuration'
require 'ostruct'
require 'yaml'
require 'rails_generator/secret_key_generator'  

Rails::Initializer.run do |config|
  
  begin
    application_config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
    env_config = application_config.send(RAILS_ENV)
    application_config.common.update(env_config) unless env_config.nil?
  rescue Exception
    application_config = OpenStruct.new()
  end

  # Merge database & config.yml into ::AppConfig
  unless application_config.common.nil?
    application_config.common.keys.each do |key|
      config.app_config[key] = application_config.common[key]
    end
  end
  
  #create new session key for each site, so that there arent a million sites all with the same key
  session_key = "#{config.app_config['site_name'].downcase.gsub!(/\ +/, '_')}_session"
  secret_file = File.join(RAILS_ROOT, "secret")  
  if File.exist?(secret_file)  
    secret = File.read(secret_file)  
  else  
    secret = Rails::SecretKeyGenerator.new(session_key).generate_secret  
    File.open(secret_file, 'w') { |f| f.write(secret) }  
  end  
  config.active_record.observers = :user_observer
  config.action_controller.session = {
    #converts site name to lowercase and swaps all spaces for underscores if they havent been caught already
    :session_key => session_key,
    :secret      => secret
  }
end

SITE_KEY = 'base' # Used for session key
