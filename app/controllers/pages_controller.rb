# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Pages in the site
class PagesController < ApplicationController
  before_filter :find_page, :only => [:show, :edit, :update, :destroy, :versions, :enable, :revert_to_version]
  before_filter :login_required, :except => :show
  before_filter :page_enabled, :only => :show
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]

  # List all pages. Requires Admin User
  def index
    @all_top_level_pages = Page.parentless
    render :action => "index", :layout => "admin"
  end

  # Show the page and its details. Page must be enabled or user must be admin.
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # Create a new page
  def new
    @page = Page.new
    if Page.find_by_slug(params[:id])
      @parent_id = Page.find_by_slug(params[:id]).id
    else
      @parent_id = "0"
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
  end

  # Save the new page. Part 2 of the new method.
  def create
    @page = Page.new(params[:page])
    
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update the pages details. Second half of edit method.
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Delete the page. Does not delete children.
  def destroy
    @page.destroy!
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
    @versions = @page.versions
  end
  
  # Change the page back to a previous version.
  def revert_to_version
    @version = @page.versions.find_by_version(params[:version])
    @page.title = @version.title
    @page.body = @version.body
    @page.slug = @version.slug
    @page.save
    redirect_to_pages
  end
  
  private
    # Find a page by its slug
    def find_page
      @page = Page.find_by_slug(params[:id])
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
        format.html { redirect_to(pages_url) }
        format.xml { head :ok }
      end
    end
end
