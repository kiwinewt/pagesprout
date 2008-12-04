# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Posts in the site, each of which is linked to a blog.
class PostsController < ApplicationController
  layout 'admin'
  
  before_filter :find_post, :only => [:show, :edit, :update, :destroy, :enable]
  before_filter :find_blog
  before_filter :login_required, :except => :show
  before_filter :post_enabled, :only => :show
  # GET /posts/1
  # GET /posts/1.xml
  def show
    respond_to do |format|
      format.html { render :layout => 'master' } # show.html.erb
      format.xml  { render :xml => @post }
    end
    rescue ActionView::TemplateError
      r = "\n\n"
      r = @post.inspect
      r << "\n\n" + @post.user_id.to_s
      raise r
  end
  
  # GET /posts
  # GET /posts
  def index
    @posts = @blog.posts
  end


  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @post.enabled = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.blog = @blog
    @post.user = current_user
    
    # TODO move this into model
    @post.permalink = Time.now.strftime('%Y-%m-%d-')+@post.title.gsub(/[" "]/, '-')

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to_blogs }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to_blogs }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post.destroy
    flash[:notice] = 'Post was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to_blogs }
      format.xml  { head :ok }
    end
  end
  
  # Toggle the enabled state of the post
  def enable
    @post.toggle_enabled!
    redirect_to_blogs
  end
  
  private
  
    # Find the current post
    def find_post
      @post = Post.find_by_permalink(params[:id])
      @page_title = @post.title
    end
    
    # Find the current post's blog
    def find_blog
      @blog = Blog.find_by_permalink(params[:blog_id])
    end
    
    # Make sure diabled posts are only accessible by the Admin user
    def post_enabled
      # if the page is active then let it through
      # if not then the user has to be an admin to access it
      @post.enabled? || check_administrator_role
    end
    
    # Go to the blogs list page
    def redirect_to_blogs
      respond_to do |format|
        format.html { redirect_to(blogs_url) }
        format.xml { head :ok }
      end
    end
end
