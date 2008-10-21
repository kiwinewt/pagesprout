# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class ContactMailer < ActionMailer::Base
  # Pass the email fields to the view so that an email can be sent.
  # Called from the contact form.
  def message_from_visitor(mail_info)
    @subject = "["+AppConfig.site_name+"] Contact Form"
    @body['from'] = mail_info["from_name"]
    @body['email'] = mail_info["from_email"]
    @body['subject'] = mail_info["subject"]
    @body['message'] = mail_info["message"]
    @recipients = AppConfig.contact_email
    @from = AppConfig.admin_email
    @sent_on = Time.now
    @headers = {}
  end
end
