class AboutController < ApplicationController
  skip_before_filter :login_required

  def index
    # Find the Page that has the homepage set. Will be nil if none
    @page = Page.find_by_home_page(true, :first)
    # if there is no Page then the flash will be shown
    # if there is a page it will flashed on the next page
    notice = params[:notice]
    error = params[:error]
    if @page
      if error
        flash[:error] = error
      elsif notice
        flash[:notice] = notice
      end
      redirect_to(@page)
    end
  end
  
  def sitemap
    @pages = Page.find(:all, :conditions => { :enabled => true }, :order => "updated_at DESC", :limit => 500)
    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry. 
    headers["Last-Modified"] = @pages[0].updated_at.httpdate  
    @blogs = Blog.find(:all, :conditions => { :enabled => true }, :order => "updated_at DESC", :limit => 500) 
    headers["Last-Modified"] = headers["Last-Modified"] > @pages[0].updated_at.httpdate ? headers["Last-Modified"] : @pages[0].updated_at.httpdate 
    render :action => "sitemap", :layout => false
  end

  
  def errorpage
    # if there is a notice/error it will be passed on, otherwise the default will be used
    notice = params[:notice]
    error = params[:error]
    if !notice && !error
      error = AppConfig.page_not_found
    end
    # if there is a page pass the flash as a parameter, otherwise flash
    @page = Page.find_by_home_page(true, :first)
    if @page
      if error
        flash[:error] = error
        redirect_to :action => 'index', :error => error
      else
        flash[:notice] = notice
        redirect_to :action => 'index', :notice => notice
      end
    else
      if error
        flash[:error] = error
        redirect_to :action => 'index'
      else
        flash[:notice] = notice
        redirect_to :action => 'index'
      end
    end
  end

end
