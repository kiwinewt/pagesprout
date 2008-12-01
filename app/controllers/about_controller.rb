# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the welcome screen if there is no page defined, searching and other misc items
class AboutController < ApplicationController

  # Handle requests from the search box/form, process them then display the results in a page.
  # Requres Ferret and acts_as_ferret.
  def search
    if params[:query].present?
      @query = params[:query]
      @results = Page.enabled.find_by_contents(@query, { :multi => [Post, Blog] })
    end
  end

  # Either display the error passed or pass on the default error.
  # Has some quirks to allow multiple levels of redirect in the index action.
  def errorpage
    # if there is a notice/error it will be passed on, otherwise the default will be used
    notice = params[:notice]
    error = params[:error]
    if !notice && !error
      error = AppConfig.page_not_found
    end
    flash[:error] = error if error
    flash[:notice] = notice if notice
    if @page = Page.home
      redirect_to(@page)
    else
      redirect_to :action => 'index'
    end
  end
  
  # Take the details from the contact form and pass them to the ContactMailer so that they can be sent.
  # On error it will send the user back to the home page with an error message
  def send_contact_form
    if request.post?
      from_name = params[:name]
      from_email = params[:email]
      message = params[:message]
      subject = params[:subject]
      begin
        # First check that the recaptcha is to be used, then verify the tags
        if !AppConfig.recaptcha_public_key.blank? && !AppConfig.recaptcha_private_key.blank?
          if !verify_recaptcha
            # if the captcha tags are invalid, redirect back
            flash[:error] = 'Please enter the correct CAPTCHA tags.'
            redirect_to(:action => 'contact')
          end
        end
        #Then check if the senders email is valid
        if from_email =~ /^[a-zA-Z0-9._%-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}$/
          #put all the contents of my form in a hash
          mail_info = {"from_name" => from_name, "from_email" => from_email, "message" => message, "subject" => subject}
          ContactMailer.deliver_message_from_visitor(mail_info)
          #Display a message notifying the sender that his email was delivered.
          flash[:notice] = 'Your message was successfully delivered.'
          #Then redirect to index or any page you want with the message
          redirect_to(:action => 'index')
        else
          #if the senders email address is not valid
          #display a warning and redirect to any action you want
          flash[:error] = 'Your email address appears to be invalid.'
          redirect_to(:action => 'contact')
        end
      rescue
        #if everything fails, display a warning and the exception
        #Maybe not always advisable if your app is public
        #But good for debugging, especially if action mailer is setup wrong
        flash[:error] = "Your message could not be delivered at this time. Please try again later"
        redirect_to(:action => 'contact')
      end
    end
  end

end
