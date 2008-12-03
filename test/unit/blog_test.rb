require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  
  test "invalid fields" do
    blog = Blog.new
    assert !blog.valid?
    assert blog.errors.invalid?(:title)
    assert blog.errors.invalid?(:description)
    assert blog.errors.invalid?(:permalink)
  end
  
end
