# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

# Class to do all emailing not related to the user specifically, e.g: contact form
class Emailer < ActionMailer::Base

  # Pass the email fields to the view so that an email can be sent.
  # Called from the contact form.
  def message_from_visitor(mail_info)
    @subject = "["+AppConfig.site_name+"] Contact Form"
    @recipients = AppConfig.contact_email
    @from = AppConfig.contact_email
    @reply_to = mail_info[:email]
    @sent_on = Time.now
    @headers = {}
    @body['name'] = mail_info[:name]
    @body['email'] = mail_info[:email]
    @body['subject'] = mail_info[:subject]
    @body['message'] = mail_info[:message]
  end
end
