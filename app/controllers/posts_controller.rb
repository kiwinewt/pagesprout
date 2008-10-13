class PostsController < ApplicationController
  before_filter :find_post, :only => [:show, :edit, :update, :destroy, :enable]
  before_filter :get_blog
  before_filter :login_required, :except => :show
  before_filter :post_enabled, :only => :show
  # GET /posts/1
  # GET /posts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
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
    @post.blog_id = Blog.find_by_slug(params[:blog_id]).id || Blog.find_by_slug(@blog.id).id
    @post.slug = Time.now.strftime('%Y-%m-%d-')+@post.title.gsub(/[" "]/, '-')

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to([@blog,@post]) }
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
        format.html { redirect_to(@blog,@post) }
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
      format.html { redirect_to(blogs_path) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @post.enabled = !@post.enabled
    @post.save
    redirect_to_blogs
  end
  
  private
  
    def find_post
      @post = Post.find_by_slug(params[:id])
      @page_title = @post.title
    end
    
    def get_blog
      @blog = Blog.find_by_slug(params[:blog_id])
    end
    
    def post_enabled
      # if the page is active then let it through
      # if not then the user has to be an admin to access it
      @post.enabled? || check_administrator_role
    end
    
    def redirect_to_blogs
      respond_to do |format|
        format.html { redirect_to(blogs_url) }
        format.xml { head :ok }
      end
    end
end
