# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
module ApplicationHelper
  
  # If a theme is set then use it, otherwise display the default theme.
  def theme
    AppConfig.theme || 'default'
  end
  
  # Theme stylesheet location.
  def theme_stylesheet
    "/themes/#{theme}/stylesheets/master"
  end
  
  # Retrieve navigation and subnav list:
  # * Home page
  # * Pages
  # * Blogs
  # * Admin Link
  # * Login/out
  # TODO move navigation instance variables to controller
  def get_navigation
    @pages = []
    @pages << (link_to('Home', root_path))
    # TODO change complicated finds to named scopes
    @pages += Page.enabled.parentless(:all, :conditions => { :home => false }).collect { |p| link_to(h(p.title), p) }
    @pages += Blog.enabled(:all).collect { |p| link_to(h(p.title), p) }
    @pages << link_to('Contact Us', :controller => 'about', :action => 'contact')
    @pages << link_to_if(!logged_in?, "Log In", new_session_path) do
      @pages << link_to_if(current_user.has_role?('administrator'),'Site Administration', admin_path)
      link_to('Log Out', logout_url)
    end
    if @page
      if @page.root?
        if @page.children.count != 0
          @subnav = true
          @sub_pages = Page.find(:all, :conditions => { :enabled => true, :parent_id => @page.id }).collect { |p| link_to(h(p.title), p) }
        end
      else
        @subnav = true
        @sub_pages = Page.find(:all, :conditions => { :enabled => true, :parent_id => @page.parent_id }).collect { |p| link_to(h(p.title), p) }
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
    content_tag(:div, text, :class => 'heading')
  end
  
  # Add the links for the scripts to the code
  def scripts
    render(:partial => 'layouts/scripts') + @content_for_scripts.to_s
  end
  
  # Add the page footer to the code
  def footer
    render :partial => 'layouts/footer'
  end
  
  # return the number of themes
  # TODO should be part of a theme model
  def count_themes
    result = {}
    files = Dir.entries("#{RAILS_ROOT}/public/themes/")
    files.each do |file|
      file.to_s
      if !file.include? "."
        result[file] = file
      end
    end
    result.count
  end

end
