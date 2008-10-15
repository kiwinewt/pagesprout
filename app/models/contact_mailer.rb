class ContactMailer < ActionMailer::Base
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
