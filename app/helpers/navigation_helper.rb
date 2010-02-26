module NavigationHelper
  
  # Define your breadcrumb navigation in a block
  def breadcrumbs(&block)
    content = capture(&block)
    concat content_tag(:div, content, :class => 'breadcrumbs')
  end
  
  def navigation_list
    pages = []
    for page in Page.published.parentless
      if (expanded_page(page) && page.children?)
        kids = []
        for child in page.children
          if child.published?
            kids << "<li>" + link_to( h("- " + child.title), child ) + "</li>"
          end
        end
        if !(kids.empty?)
          pages << link_to( h(page.title), page ) + "<ul>" + kids.to_s + "</ul>"
        end
      else
        pages << link_to( h(page.title), page )
      end

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
    
  def expanded_page(page)
    result = current_page?(page)
    if !@page.nil?
      result = @page.parent==page || result
    end
    return result
  end
  
end
