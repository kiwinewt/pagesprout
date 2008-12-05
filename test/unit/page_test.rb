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
    page = pages(:test)
    assert !Page.enabled.include? (page)
    page.enabled = true
    page.save!
    assert Page.enabled.include? (page)
  end
  
  test "disables page" do
    page = pages(:test2)
    assert Page.enabled.include? (page)
    page.enabled = false
    page.save!
    assert !Page.enabled.include? (page)
  end
  
  test "update page" do
    page = pages(:test)
    old_title = page.title
    page.title = "Not a test page"
    assert_not_equal( old_title, page.title )
    old_body = page.body
    page.body = "Honest, it's not!"
    assert_not_equal( old_body, page.body )
  end
  
  test "param is permalink" do
    page = pages(:test)
    assert_equal( page.to_param, page.permalink )
  end
  
  test "permalink with spaces has spaces" do
    page = pages(:test)
    assert page.permalink_with_spaces.include? " "
  end
  
  test "is home page" do
    assert !Page.home?
    page = pages(:test)
    page.enabled = true
    page.save!
    assert Page.home?
    assert_equal( Page.home, page )
  end
  
  test "is root page" do
    page = pages(:test)
    assert page.root?
    page = pages(:test2)
    assert !page.root?
  end
  
  test "has children" do
    page = pages(:test)
    assert page.children?
    assert page.children.include? pages(:test2)
  end
  
  test "delete page" do
    page = pages(:test2)
    assert page.destroy
  end
end
