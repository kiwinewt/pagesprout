class AboutController < ApplicationController
  skip_before_filter :login_required

  def index
  end

end
