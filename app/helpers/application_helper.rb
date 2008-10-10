# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_theme_stylesheet
    if AppConfig.theme
      stylesheet = '/themes/' + AppConfig.theme + '/stylesheets/master'
    else
      stylesheet = '/themes/default/stylesheets/master'
    end
    stylesheet
  end
  
  def get_navigation
    @pages = []
    @pages << (link_to('Home', root_path))
    @pages += Page.find(:all, :conditions => { :home_page => false, :enabled => true, :parent_id => nil }).collect { |p| link_to(h(p.title), p) }
    @pages += Blog.find(:all, :conditions => { :enabled => true }).collect { |p| link_to(h(p.title), p) }
    if logged_in?
      @pages << ('Logged in as: ' + link_to(h(current_user.login.capitalize), user_path(current_user)))
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
  
  def get_page_title
    if !@page_title && !@page
      @page_title = AppConfig.site_name
    else
      @page_title = @page_title || ""
      @page_heading = @page_title
      @page_title = @page_title + ' - ' + AppConfig.site_name
    end
  end

end
