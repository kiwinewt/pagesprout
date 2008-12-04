# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
module ApplicationHelper
  
  # Retrieve navigation and subnav list:
  # * Home page
  # * Pages
  # * Blogs
  # * Admin Link
  # * Login/out
  # TODO move navigation instance variables to controller
  def get_navigation
    @pages = []
    if @home = Page.home
      @pages << link_to(@home.title, @home)
    else
      @pages << link_to('Home', root_path)
    end
    @pages += Page.enabled.parentless.collect { |p| link_to(h(p.title), p) }
    @pages += Blog.enabled.collect { |p| link_to(h(p.title), p) }
    if AppConfig.contact_enabled
      @pages << link_to('Contact Us', contact_path)
    end
    @pages << link_to_if(!logged_in?, 'Log In', new_session_path) do
      current_user.has_role?('administrator') ? @pages << link_to( 'Site Administration', admin_path ) : ""
      link_to('Log Out', logout_url)
    end
    # Collect subnav
    if @page
      if @page.children.length != 0
        @subnav = true
        @sub_pages = Page.enabled.sub_page(@page.id).collect { |p| link_to(h(p.title), p) }
      elsif !@page.root?
        @subnav = true
        @sub_pages = Page.enabled.sub_page(@page.parent_id).collect { |p| link_to(h(p.title), p) }
      end
    end
  end
  
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
