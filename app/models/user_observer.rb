# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class UserObserver < ActiveRecord::Observer
  # Send signup email once the user has been created
  def after_create(user)
    if user.id > 1
      UserMailer.deliver_signup_notification(user)
    else
      @role = Role.create(:rolename => 'administrator')
      User.find_and_activate!(user.activation_code)
      permission = Permission.new
      permission.role = @role
      permission.user = user
      permission.save(false)
    end
  end

  # Send correct email on user save
  def after_save(user)
    if user.id > 1
      UserMailer.deliver_activation(user) if user.pending?
      UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
      UserMailer.deliver_reset_password(user) if user.recently_reset_password?
    end
  end

end
