require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def test_should_get_admin_index
    user_signin
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs)
  end
  
  def test_should_not_get_unauthorised_index
    user_signin
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs)
  end

  def test_should_get_new
    user_signin
    get :new
    assert_response :success
  end

  def test_should_get_edit
    user_signin
    get :edit, :id => blogs(:ala).to_param
    assert_response :success
  end

  def test_should_not_get_unauthorised_edit
    get :edit, :id => blogs(:ala).to_param
    assert_response :redirect
  end

  def test_creates_blog
    user_signin
    assert_difference('Blog.count') do
      post :create, :blog => { :title => "Agnu Blog", :description => "A Test Blog", :permalink => "angublog" }
    end
    assert_redirected_to blogs_path
  end
  
  test "shows blog" do
    get :show, :id => blogs(:ala).to_param
    assert_response :success
  end
  
  def test_updates_blog
    user_signin
    put :update, :id => blogs(:ala).to_param, :blog => { :description => "Another Test Blog" }
    assert_redirected_to blogs_path
  end
  
  def test_deletes_blog
    user_signin
    assert_difference('Blog.count', -1) do
      delete :destroy, :id => blogs(:ala).to_param
    end
    assert_redirected_to blogs_path
  end
end
