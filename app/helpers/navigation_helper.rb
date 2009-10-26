module NavigationHelper
  
  # Define your breadcrumb navigation in a block
  def breadcrumbs(&block)
    content = capture(&block)
    concat content_tag(:div, content, :class => 'breadcrumbs')
  end
  
  def navigation_list
    pages = []
    for page in Page.published.parentless
      pages << link_to( h(page.title), page )
    end
    for blog in Blog.enabled
      pages << link_to( h(blog.title), blog )
    end
    # Example of how easy it is to add a new item to the navigation:
    pages << link_to( "Contact", contact_path )
    # Want a custom, funky external link? Simple:
    # pages << '<a href="http://www.pagesprout.com">PageSprout</a>'
    pages
  end
  
end
