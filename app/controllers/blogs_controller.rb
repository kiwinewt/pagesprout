# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of Blogs and their details.
class BlogsController < ApplicationController
  before_filter :find_blog, :only => [:show, :edit, :update, :destroy, :enable]
  before_filter :login_required, :except => :show
  before_filter :blog_enabled, :only => :show
  
  # Get a list of all blogs. Only accessible to the admin user.
  def index
    @blogs = Blog.find(:all)
    render :action => "index", :layout => "admin"
  end

  # Display the blog and all its enabled posts.
  def show
    @posts = get_posts
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # Create a new blog. Must be logged in.
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

  # Save the new blog. Second half of new method.
  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to_blogs }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update the blogs details. Second half of edit method.
  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to_blogs }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Delete the blog from the site. Does not delete posts.
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  # Toggle the enabled state of the blog.
  def enable
    @blog.enabled = !@blog.enabled
    @blog.save
    redirect_to_blogs
  end
  
  protected
    # Return an array of this blogs posts.
    # Include disabled posts if the user is an administrator.
    def get_posts
      if logged_in? && current_user.has_role?('administrator')
        @blog.posts.find(:all, {:limit => 10, :order => "updated_at DESC"})
      else
        @blog.enabled_posts_shortlist
      end
    end
  
  private  
    # Find the blog by its permalink.
    def find_blog
      @blog = Blog.find_by_permalink(params[:id])
    end
    
    # if the page is active then let it through
    # if not then the user has to be an admin to access it
    def blog_enabled
      @blog.enabled? || check_administrator_role
    end
    
    # Redirect to the correct place to list the blogs.
    def redirect_to_blogs
      respond_to do |format|
        format.html { redirect_to(blogs_url) }
        format.xml { head :ok }
      end
    end
end
