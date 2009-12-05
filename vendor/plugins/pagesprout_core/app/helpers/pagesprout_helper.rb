# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

module PagesproutHelper
  
  # Add the links for the scripts to the code
  def scripts
    @content_for_scripts.to_s
  end
  
  def flashes
    flash.collect { |k, v| content_tag(:div, v, :class => "flash #{k}") }
  end
  
  # Add the page footer to the code
  def footer
    render :partial => 'layouts/footer'
  end
  
  def link_with_selected(name, options = {}, *for_controllers)
    if for_controllers
      selected = for_controllers.map(&:to_s).include?(controller.controller_name)
    end
    selected ||= current_page?(options)
    link_to(name, options, :class => ('selected' if selected))
  end
  
  def subnavigation_for(page)
    content_tag(:div, list_for_page(page, :class => 'pages'), :class => 'nav')
  end
  
  def list_for_page(page, options = {})
    content_tag(:ul, page.children.map { |child|
      content_tag(:li, link_to(h(child.title), child) + list_for_page(child))
    }, options)
  end

end
