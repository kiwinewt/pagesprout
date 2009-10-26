require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  test "should get index" do
    user_signin
    get :index, :blog_id => blogs(:ala).to_param
    assert_response :success
  end

  test "should get new" do
    user_signin
    get :new, :blog_id => blogs(:ala).to_param
    assert_response :success
  end

  test "should create post" do
    user_signin
    assert_difference('Post.count') do
      post :create, { :blog_id => blogs(:ala).to_param, :post => { :title => "New Post", :body => "A Post", :enabled => true } }
    end

    assert_response :redirect
  end

  test "should show post" do
    post = posts(:first)
    get :show, { :blog_id => post.blog.to_param, :id => post.to_param }
    assert_response :success
  end

  test "should destroy post" do
    user_signin
    blog = posts(:first).blog
    assert_difference('Post.count', -1) do
      delete :destroy, { :blog_id => blog, :id => posts(:first).to_param }
    end

    assert_response :redirect
  end
end
