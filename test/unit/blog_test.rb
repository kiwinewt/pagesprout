require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  
  test "invalid fields" do
    blog = Blog.new
    assert !blog.valid?
    assert blog.errors.invalid?(:title)
    assert blog.errors.invalid?(:description)
    assert blog.errors.invalid?(:permalink)
  end
  
  test "create blog" do
    assert Blog.create( :title => "A Blog", :description => "A Test Blog", :permalink => "test_blog")
  end
  
  test "enables blog" do
    assert true
  end
  
  test "disables blog" do
    assert true
  end
  
end
