require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  test "invalid fields" do
    post = Post.new
    assert !post.valid?
    assert post.errors.invalid?(:title)
    assert post.errors.invalid?(:body)
    assert post.errors.invalid?(:permalink)
  end
  
  test "invalid permalink" do
    post = Post.new( :title => "A Post", :body => "A Test Post", :permalink => "2008-10-12-First")
    assert !post.valid?
    assert post.errors.invalid?(:permalink)
  end
  
  test "create post" do
    assert Post.create( :title => "Test Post", :body => "A Test Post", :permalink => "2008-10-13-test_post")
  end
  
  test "enables post" do
    post = posts(:nuva)
    assert !post.enabled?
    post.toggle_enabled!
    assert post.enabled?
  end
  
  test "disables post" do
    post = posts(:first)
    assert post.enabled?
    post.toggle_enabled!
    assert !post.enabled?
  end
  
  test "update post" do
    post = posts(:first)
    old_title = post.title
    post.title = "Not a list apart"
    assert_not_equal( old_title, post.title )
    old_body = post.body
    post.body = "Not a post, really..."
    assert_not_equal( old_body, post.body )
  end
  
  test "param is permalink" do
    post = posts(:first)
    assert_equal( post.to_param, post.permalink )
  end
  
  test "permalink with spaces has spaces" do
    post = posts(:first)
    assert post.permalink_with_spaces.include? " "
  end
  
  test "delete post" do
    post = posts(:first)
    assert post.destroy
  end
end
