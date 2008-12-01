# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
module ThemeHelper
  
  # Theme stylesheet location.
  def theme_stylesheet
    "/themes/#{Theme.active.name}/stylesheets/master"
  end

end