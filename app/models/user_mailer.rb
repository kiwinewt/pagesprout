# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

# Class to do all emailing of activation codes/etc.
class UserMailer < ActionMailer::Base
  include ActionController::UrlWriter
  
  # FIXME use :only_path => false on links (move out of pretty paths)
  
  # Send signup notification
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = activation_url(user.activation_code)
  end
  
  # Send post-activation email
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = root_url
  end
  
  # Send reset password link
  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested to change your password'
    @body[:url]  = reset_password_url(user.password_reset_code)
  end
  
  # Send post-password-change email
  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset.'
  end
  
  protected
    # Do common email setup
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = AppConfig.contact_email
      @subject     = "["+AppConfig.site_name+"] "
      @sent_on     = Time.now
      @body[:user] = user
    end

end
