class AboutController < ApplicationController
  skip_before_filter :login_required

  def index
    @page = Page.find_by_home_page(true, :first)
    if @page
      flash[:notice] = params[:notice]
      flash[:error] = params[:error]
      redirect_to(@page)
    end
  end
  
  def errorpage
    notice = params[:notice]
    error = params[:error]
    if !notice && !error
      error = AppConfig.page_not_found
    end
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
