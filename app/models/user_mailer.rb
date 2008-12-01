# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# Class to do all emailing of activation codes/etc.
class UserMailer < ActionMailer::Base
  # Send signup notification
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = url_for(:controller => '') + "activate/#{user.activation_code}"
  end
  
  # Send post-activation email
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = url_for(:controller => '')
  end
  
  # Send reset password link
  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested to change your password'
    @body[:url]  = url_for(:controller => '') + "/reset_password/#{user.password_reset_code}"
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
