class AboutController < ApplicationController
  skip_before_filter :login_required

  def index
    # Find the Page that has the homepage set. Will be nil if none
    @page = Page.find_by_home_page(true, :first)
    # if there is no Page then the flash will be shown
    # if there is a page it will flashed on the next page
    notice = params[:notice]
    error = params[:error]
    if @page
      if error
        flash[:error] = error
      elsif notice
        flash[:notice] = notice
      end
      redirect_to(@page)
    end
  end

  def search
    begin
      @query = params[:query]
      if @query == ""
        @query = nil
      end
      # add any other models that are acts_as_ferret here
      additional_models = [Post, Blog]
      @result = Page.find_by_contents(@query, {:multi => additional_models}, {:conditions => "enabled = true"})
    rescue
      flash[:error] = "Please enter something to search for"
      redirect_to(:controller => :about, :action => :index)
    end
  end
  
  def sitemap
    @pages = Page.find(:all, :conditions => { :enabled => true }, :order => "updated_at DESC", :limit => 500)
    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry. 
    headers["Last-Modified"] = @pages[0].updated_at.httpdate  
    @blogs = Blog.find(:all, :conditions => { :enabled => true }, :order => "updated_at DESC", :limit => 500) 
    headers["Last-Modified"] = headers["Last-Modified"] > @pages[0].updated_at.httpdate ? headers["Last-Modified"] : @pages[0].updated_at.httpdate 
    render :action => "sitemap", :layout => false
  end

  
  def errorpage
    # if there is a notice/error it will be passed on, otherwise the default will be used
    notice = params[:notice]
    error = params[:error]
    if !notice && !error
      error = AppConfig.page_not_found
    end
    # if there is a page pass the flash as a parameter, otherwise flash
    @page = Page.find_by_home_page(true, :first)
    if @page
      if error
        flash[:error] = error
        redirect_to :action => 'index', :error => error
      else
        flash[:notice] = notice
        redirect_to :action => 'index', :notice => notice
      end
    else
      if error
        flash[:error] = error
        redirect_to :action => 'index'
      else
        flash[:notice] = notice
        redirect_to :action => 'index'
      end
    end
  end
  
  def send_contact_form
    if request.post?
      from_name = params[:name]
      from_email = params[:email]
      message = params[:message]
      subject = params[:subject]
      begin
        #First check if the senders email is valid
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
          redirect_to(:action => 'index')
        end
      rescue
        #if everything fails, display a warning and the exception
        #Maybe not always advisable if your app is public
        #But good for debugging, especially if action mailer is setup wrong
        flash[:error] = "Your message could not be delivered at this time. #$!. Please try again later"
        redirect_to(:action => 'index')
      end
    end
  end

end
