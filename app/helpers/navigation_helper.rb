module NavigationHelper
  
  # Define your breadcrumb navigation in a block
  def breadcrumbs(&block)
    content = capture(&block)
    concat content_tag(:div, content, :class => 'breadcrumbs')
  end
  
end