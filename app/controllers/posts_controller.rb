# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
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
    @keywords = @post.keywords unless @post.keywords.blank?
    respond_to do |format|
      format.html { render :layout => 'master' } # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  # GET /posts
  def index
    @posts = @blog.posts
  end
  
  # GET /posts/published
  def published
    @posts = @blog.posts.published
    render :action => 'index'
  end
  
  # GET /posts/draft
  def draft
    @posts = @blog.posts.draft
    render :action => 'index'
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

    respond_to do |format|
      if @post.save
        flash[:success] = 'Post was successfully created.'
        format.html { redirect_to blog_posts_path(@blog) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        puts @post.errors
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
        flash[:success] = 'Post was successfully updated.'
        format.html { redirect_to blog_posts_path(@blog) }
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
    
    flash[:success] = 'Post was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to blog_posts_path(@blog) }
      format.xml  { head :ok }
    end
  end
  
  # Toggle the enabled state of the post
  def enable
    @post.toggle_enabled!
    
    flash[:success] = "Post #{@post.enabled? ? 'enabled' : 'disabled'} successfully."
    
    redirect_to blog_posts_path(@blog)
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
end
