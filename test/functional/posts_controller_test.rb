require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def test_should_get_new
    user_signin
    get :new, :blog_id => Blog.find(1).slug
    assert_response :success
  end

  def test_should_create_post
    user_signin
    assert_difference('Post.count') do
      post :create, {:blog_id => Blog.find(1).slug, :post => { :title => "New Post", :body => "A Post", :enabled => 1}}
    end
    
    @blog = Blog.find(1).slug
    @post = Time.now.strftime('%Y-%m-%d-')+"new post".gsub(/[" "]/, '-')

    assert_redirected_to blog_post_path(:blog_id => @blog, :id => @post)
  end

  def test_should_show_post
    post = Post.find(1)
    get :show, {:blog_id => Blog.find(post.blog_id).slug, :id => post.slug}
    assert_response :success
  end

  def test_should_destroy_post
    user_signin
    @blog = Blog.find(posts(:one).blog_id).slug
    assert_difference('Post.count', -1) do
      delete :destroy, {:blog_id => @blog, :id => posts(:one).slug}
    end

    assert_redirected_to blog_path(@blog)
  end
end
