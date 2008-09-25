# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => AppConfig.mail_address,
  :port => AppConfig.mail_port,
  :domain => AppConfig.mail_domain,
  :authentication => :login,
  :user_name => AppConfig.mail_user_name,
  :password => AppConfig.mail_password
}

