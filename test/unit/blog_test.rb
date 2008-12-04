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
    blog = blogs(:hidden)
    assert !blog.enabled?
    blog.enabled = true
    assert blog.enabled?
  end
  
  test "disables blog" do
    blog = blogs(:ala)
    assert blog.enabled?
    blog.enabled = false
    assert !blog.enabled?
  end
  
  test "update blog" do
    blog = blogs(:ala)
    old_title = blog.title
    blog.title = "Not a list apart"
    assert_not_equal( old_title, blog.title )
    old_desc = blog.description
    blog.description = "Not a blog, really..."
    assert_not_equal( old_desc, blog.description )
  end
  
  test "param is permalink" do
    blog = blogs(:ala)
    assert_equal( blog.to_param, blog.permalink )
  end
  
  test "permalink with spaces has spaces" do
    blog = blogs(:ala)
    assert blog.permalink_with_spaces.include? " "
  end
  
  test "pages" do
    blog = blogs(:ala)
    assert blog.posts?
    assert blog.enabled_posts_shortlist.count >= 1
  end
  
  test "delete blog" do
    blog = blogs(:ala)
    assert blog.destroy
  end
  
end
