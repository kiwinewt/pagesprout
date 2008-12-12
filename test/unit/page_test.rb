require 'test_helper'

class PageTest < ActiveSupport::TestCase
  
  test "invalid fields" do
    page = Page.new
    assert !page.valid?
    assert page.errors.invalid?(:title)
    assert page.errors.invalid?(:body)
    assert page.errors.invalid?(:permalink)
  end
  
  test "create page" do
    assert Page.create( :title => "A page", :body => "A Test page", :permalink => "test_page")
  end
  
  test "enables page" do
    page = pages(:home)
    assert !Page.enabled.include?(page)
    page.enabled = true
    page.save!
    assert Page.enabled.include?(page)
  end
  
  test "disables page" do
    page = pages(:sub_page)
    assert Page.enabled.include?(page)
    page.enabled = false
    page.save!
    assert !Page.enabled.include?(page)
  end
  
  test "update page" do
    page = pages(:home)
    old_title = page.title
    page.title = "Not a test page"
    assert_not_equal( old_title, page.title )
    old_body = page.body
    page.body = "Honest, it's not!"
    assert_not_equal( old_body, page.body )
  end
  
  test "param is permalink" do
    page = pages(:home)
    assert_equal( page.to_param, page.permalink )
  end
  
  test "permalink with spaces has spaces" do
    page = pages(:home)
    assert page.permalink_with_spaces.include? " "
  end
  
  test "is home page" do
    assert !Page.home?
    page = pages(:home)
    page.enabled = true
    page.save!
    assert Page.home?
    assert_equal( Page.home, page )
  end
  
  test "is root page" do
    page = pages(:home)
    assert page.root?
    page = pages(:sub_page)
    assert !page.root?
  end
  
  test "has children" do
    page = pages(:home)
    assert page.children?
    assert page.children.include? pages(:sub_page)
  end
  
  test "delete page" do
    page = pages(:sub_page)
    assert page.destroy
  end
  
  test "author" do 
    page = pages(:home)
    assert page.user
    assert page.author
    assert page.user == page.author
  end
  
  test "deleting a page pops its descendents" do
    page = pages(:home)
    original_parent = page.parent
    assert page.children?
    sub_page = page.children.first
    assert sub_page.children?
    sub_sub_page = sub_page.children.first
    # Delete the page
    assert page.destroy
    # Check that the sub page's new parent is the original parent of the page that got deleted
    assert sub_page.parent == original_parent
    # Assert that the sub sub page still has the sub page as its parent
    assert sub_sub_page.parent == sub_page
  end
  
  test "publishes draft" do
    # TODO write test
  end
end
