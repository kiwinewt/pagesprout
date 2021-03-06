# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Pages in the site
class PagesController < ApplicationController
  layout 'admin'
  
  before_filter :find_page, :only => [:show, :edit, :update, :destroy, :versions, :enable, :revert_to_version]
  before_filter :login_required, :except => [:show, :index, :sitemap, :contact]
  before_filter :page_enabled, :only => :show

  # If there is a homepage set, redirect to it, otherwise display the uber-basic welcome page.
  def index # todo: not redirect?
    if @page = Page.home
      # included for places that redirect here with a flash
      flash.keep
      redirect_to(@page)
    else
      render :layout => 'master'
    end
  end

  def contact
    render :layout => 'master'
  end 

  # GET /pages/list
  def list
    @pages = Page.parentless
    render :action => "list"
  end
  
  # GET /pages/published
  def published
    @pages = Page.published
    @sort = :published
    render :action => 'list'
  end
  
  # GET /pages/draft
  def draft
    @pages = Page.draft
    @sort = :draft
    render :action => 'list'
  end

  # Show the page and its details. Page must be enabled or user must be admin.
  def show
    @keywords = @page.keywords unless @page.keywords.blank?
    respond_to do |format|
      format.html { render :layout => 'master' } # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # Create a new page
  def new
    @page = Page.new
    @page.home_page = true if @page.first_page?
    @page.parent = Page.find_by_permalink(params[:id]) if params[:id]
  end

  # GET /pages/1/edit
  def edit
  end

  # Save the new page. Second half of the new method.
  def create
    @page = Page.new(params[:page])
    @page.user = current_user
    @page.parent_id = nil if @page.parent_id == 0
    
    # set the first page created as main home page
    if @page.first_page?
      @page.home_page = true
      @page.enabled = true # TODO reflect view with this
    end
    
    respond_to do |format|
      if @page.save
        flash[:success] = 'Page was successfully created.'
        format.html { redirect_to_pages }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update the pages details. Second half of the edit method.
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:success] = 'Page was successfully updated.'
        format.html { redirect_to_pages }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Delete the page. Does not delete children.
  def destroy
    @page.destroy
    flash[:success] = 'Page was successfully deleted.'
    redirect_to_pages
  end
  
  # Toggle the enabled/disabled state of a page.
  def enable
    @page.enabled = !@page.enabled
    @page.save
    redirect_to_pages
  end
  
  # Return a list of all the versions of a page.
  def versions
    @versions = @page.versions.reverse # TODO set versions to order by revisions descending by default
  end
  
  # Change the page back to a previous version.
  def revert_to_version
    @version = @page.versions.find_by_version(params[:version])
    @page.title = @version.title
    @page.body = @version.body
    @page.permalink = @version.permalink
    @page.save
    redirect_to_pages
  end
  
  # Produce and display a google sitemap at http://site_root/sitemap.xml.
  # The URL can be passed to google so it will be dynamically updated.
  def sitemap
    @home_page = Page.home || nil
    @pages = Page.enabled
    @blogs = Blog.enabled
    
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
    
  # Take the details from the contact form and pass them to the Emailer so that they can be sent.
  # On error it will send the user back to the home page with an error message
  def send_contact_form
    if request.post?
      begin
        if !AppConfig.recaptcha_public_key.blank? && !AppConfig.recaptcha_private_key.blank?
          if !verify_recaptcha
            flash[:error] = 'Please enter the correct CAPTCHA tags.'
            redirect_to(:action => 'contact')
          end
        end
        if params[:email] =~ /^[a-zA-Z0-9._%-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}$/
          Emailer.deliver_message_from_visitor(params)
          flash[:notice] = 'Your message was successfully delivered.'
          redirect_to(:action => 'index')
        else
          flash[:error] = 'Your email address appears to be invalid.'
          redirect_to(:action => 'contact')
        end
      rescue
        flash[:error] = "Your message could not be delivered at this time. Please try again later"
        redirect_to(:action => 'contact')
      end
    end
  end

  # Either display the error passed or pass on the default error.
  def errorpage
    # if there is a notice/error it will be passed on, otherwise the default will be used
    notice = flash['notice']
    error = flash['error']
    if !notice && !error
      flash[:error] = AppConfig.page_not_found
    else
      flash.keep
    end
    if @page = Page.home
      redirect_to(@page)
    else
      redirect_to :action => 'index'
    end
  end
  
  private
    # Find a page by its permalink
    def find_page
      @page = Page.find_by_permalink(params[:id])
      @page_title = @page.title
    end
    
    # if the page is active then let it through
    # if not then the user has to be an admin to access it
    def page_enabled
      @page.enabled? || check_administrator_role
    end
    
    # Redirect to the correct place to list the pages.
    def redirect_to_pages
      respond_to do |format|
        format.html { redirect_to(page_list_url) }
        format.xml { head :ok }
      end
    end
end
