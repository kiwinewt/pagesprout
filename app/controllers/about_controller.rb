class AboutController < ApplicationController
  skip_before_filter :login_required

  def index
    @page = Page.find_by_home_page(true, :first)
    if @page
      redirect_to(@page)
    end
  end

end
