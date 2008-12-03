# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'plugins/app_config/lib/configuration'
require 'ostruct'
require 'ferret'
require 'yaml'
require 'action_mailer'
require 'rails_generator/secret_key_generator'

Rails::Initializer.run do |config|
  
  # Pull in the config.yml file and use it to generate the AppConfig details
  begin
    application_config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml"))
  end

  # Merge config.yml into ::AppConfig
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
    secret = ActiveSupport::SecureRandom.hex(64) 
    File.open(secret_file, 'w') { |f| f.write(secret) }  
  end
  
  config.active_record.observers = :user_observer
  config.action_controller.session = {
    #converts site name to lowercase and swaps all spaces for underscores if they havent been caught already
    :session_key => session_key,
    :secret      => secret
  }
  
  RECAPTCHA_PUBLIC_KEY = config.app_config['recaptcha_public_key']
  RECAPTCHA_PRIVATE_KEY = config.app_config['recaptcha_private_key']
end

SITE_KEY = 'base' # Used for session key
