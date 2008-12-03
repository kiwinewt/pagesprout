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
    get :edit, :id => blogs(:one).permalink
    assert_response :success
  end

  def test_should_not_get_unauthorised_edit
    get :edit, :id => blogs(:one).permalink
    assert_response :redirect
  end

  def test_blog_CRUD
    user_signin
    
    # Create
    assert_difference('Blog.count') do
      post :create, :blog => { :title => "Agnu Blog", :description => "A Test Blog", :permalink => "angublog" }
    end
    assert_redirected_to blogs_path
    
    # Retrieve
    get :show, :id => blogs(:one).permalink
    assert_response :success
    
    # Update
    put :update, :id => blogs(:one).permalink, :blog => { :title => blogs(:one).title, :description => "Another Test Blog", :permalink => blogs(:one).permalink }
    assert_redirected_to blogs_path
    
    # Delete
    assert_difference('Blog.count', -1) do
      delete :destroy, :id => blogs(:one).permalink
    end

    assert_redirected_to blogs_path
  end
end
