class PagesController < ApplicationController
  before_filter :find_page, :only => [:show, :edit, :update, :destroy, :versions, :revert_to_version]
  before_filter :find_deleted_page, :only => [:completely_destroy, :restore]
  before_filter :login_required, :except => :show
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all
    @deleted_pages = Page.deleted

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.xml
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

  # PUT /pages/1
  # PUT /pages/1.xml
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

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page.destroy
    redirect_to_pages
  end
  
  def restore
    @page.recover!
    redirect_to_pages
  end
  
  def completely_destroy
    @page.destroy!
    redirect_to_pages
  end
  
  def completely_destroy_deleted
    Page.delete_all!("deleted_at IS NOT NULL")
    redirect_to_pages
  end
  
  def versions
    @versions = @page.versions
  end
  
  def revert_to_version
    @version = @page.versions.find_by_version(params[:version])
    @page.title = @version.title
    @page.body = @version.body
    @page.slug = @version.slug
    @page.save
    redirect_to_pages
  end
  
  private
  
  def find_page
    @page = Page.find_by_slug(params[:id])
    @page_title = @page.title
  end
  
  def find_deleted_page
    @page = Page.find_with_deleted(:first, :conditions => { :slug => params[:id] })
  end
  
  def redirect_to_pages
    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml { head :ok }
    end
  end
end
