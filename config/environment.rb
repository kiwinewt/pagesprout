# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

SITE_KEY = 'base' # Used for session key
SITE_NAME = 'Example'
SITE_DOMAIN = 'example.com'
ADMIN_EMAIL = 'joe.bloggs@example.com'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.active_record.observers = :user_observer
  config.action_controller.session = {
    :session_key => '_project_orc_session',
    :secret      => '4607157323cc96f80b71503dc892531aab621e3ee66568a419a0a92c0fa6700199bc6129e7d2df934004451b4b77642c913d7ddca31e20c0a72ccab86a5e3f5e'
  }
  
end
