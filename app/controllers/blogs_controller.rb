class BlogsController < ApplicationController
  before_filter :find_blog, :only => [:show, :edit, :update, :destroy]
  before_filter :login_required, :except => :show
  before_filter :blog_enabled, :only => :show
  # GET /blogs
  # GET /blogs.xml
  def index
    @blogs = Blog.find(:all)
    render :action => "index", :layout => "admin"
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    @posts = get_posts
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to(@blog) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def get_posts
      if logged_in? && current_user.has_role?('administrator')
        @blog.posts.find(:all, :limit => 10).reverse
      else
        @blog.enabled_posts_shortlist
      end
    end
  
  private  
    def find_blog
      @blog = Blog.find_by_slug(params[:id])
    end
    
    def blog_enabled
      # if the page is active then let it through
      # if not then the user has to be an admin to access it
      @blog.enabled? || check_administrator_role
    end
end
