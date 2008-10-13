class ContactMailer < ActionMailer::Base
  def message_from_visitor(mail_info)
    @subject = "Email sent via " + AppConfig.site_name;
    @body['from'] = mail_info["from_name"]
    @body['subject'] = mail_info["subject"]
    @body['message'] = mail_info["message"]
    @recipients = AppConfig.contact_email
    @from = mail_info["from_email"]
    @sent_on = Time.now
    @headers = {}
  end
end
