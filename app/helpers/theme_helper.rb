# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
module ThemeHelper
  
  # Theme stylesheet location.
  def theme_stylesheet
    warn '[DEPRECATED] Use `Theme.active.stylesheet` instead of `theme_stylesheet`'
    Theme.active.stylesheet
  end
  
  # return the number of themes
  # TODO should be part of a theme model
  def count_themes
    warn '[DEPRECATION] use `Theme.all.size` instead of `count_themes`'
    Theme.all.size
  end

end