module ApplicationHelper
  
  def theme
    AppConfig.theme || 'default'
  end
  
  def theme_stylesheet
    "/themes/#{theme}/stylesheets/master"
  end
  
  # TODO move navigation instance variables to controller
  def get_navigation
    @pages = []
    @pages << (link_to('Home', root_path))
    # TODO change complicated finds to named scopes
    @pages += Page.find(:all, :conditions => { :home_page => false, :enabled => true, :parent_id => 0 }).collect { |p| link_to(h(p.title), p) }
    @pages += Blog.find(:all, :conditions => { :enabled => true }).collect { |p| link_to(h(p.title), p) }
    @pages << link_to('Contact Us', :controller => 'about', :action => 'contact')
    if logged_in?
      #@pages << ('Logged in as: ' + link_to(h(current_user.login.capitalize), user_path(current_user)))
      if current_user.has_role?('administrator')
        @pages << (link_to('Site Administration', admin_path))
      end
      @pages << (link_to('Log Out', logout_url))
    else
      @pages << (link_to('Log In', new_session_path))
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
  # You can choose to hide the title in the view by changing the <tt><%=</tt> prefix to <tt><%</tt>.
  def page_heading(text)
    content_tag(:div, content_for(:title){ text }, :class => 'heading')
  end
  
  def scripts
    render(:partial => 'layouts/scripts') + @content_for_scripts.to_s
  end
  
  def footer
    render :partial => 'layouts/footer'
  end

end
