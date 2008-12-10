# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
module ThemeHelper
  
  # Theme stylesheet location.
  def theme_stylesheet
    # TODO set instance variable in controller to treat theme as active record
    Theme.active.stylesheet
  end
  
end