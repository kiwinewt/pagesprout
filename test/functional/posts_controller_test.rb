require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def test_should_get_index
    user_signin
    get :index, :blog_id => blogs(:ala).to_param
    assert_response :success
  end

  def test_should_get_new
    user_signin
    get :new, :blog_id => blogs(:ala).to_param
    assert_response :success
  end

  def test_should_create_post
    user_signin
    assert_difference('Post.count') do
      post :create, {:blog_id => blogs(:ala).to_param, :post => { :title => "New Post", :body => "A Post", :enabled => 1 }}
    end

    assert_redirected_to blogs_path
  end

  def test_should_show_post
    post = posts(:first)
    get :show, { :blog_id => post.blog.to_param, :id => post.to_param}
    assert_response :success
  end

  def test_should_destroy_post
    user_signin
    blog = posts(:first).blog
    assert_difference('Post.count', -1) do
      delete :destroy, {:blog_id => @blog, :id => posts(:first).to_param}
    end

    assert_redirected_to blogs_path
  end
end
