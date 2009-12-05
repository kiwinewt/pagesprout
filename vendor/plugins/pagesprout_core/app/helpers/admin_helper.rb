# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

module AdminHelper
  def alternate_row
    ' ' + cycle('odd', 'even')
  end
  
  def aside_help_for(subject)
    content_tag :div, render(:partial => "help/#{subject}"), :class => 'aside'
  end
end
