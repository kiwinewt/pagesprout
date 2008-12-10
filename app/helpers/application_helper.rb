# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

module ApplicationHelper
  
  # Returns the complete title of the page, to be used inside the title tags.
  def page_title
    (@content_for_title + " &mdash; " if @content_for_title).to_s + AppConfig.site_name
  end
  
  # Sets the page's title and displays the heading.
  # You can choose to hide the title in the view by changing the <tt>&lt;%=</tt> prefix to <tt>&lt;%</tt>.
  def page_heading(text)
    content_for(:title){ text }
    content_tag(:h1, text)
  end
  
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
  
  def link_with_selected(name, options = {}, *cont)
    if cont.length > 1
      selected = cont.map { |c| c.to_s }.include?(controller.controller_name)
    else
      selected = cont.first.to_s == controller.controller_name
    end
    selected ||= current_page?(options)
    link_to(name, options, :class => ('selected' if selected))
  end

end
