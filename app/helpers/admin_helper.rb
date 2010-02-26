# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

module AdminHelper
  def alternate_row
    ' ' + cycle('odd', 'even')
  end
  
  def aside_help_for(subject)
    content_tag :div, render(:partial => "help/#{subject}"), :class => 'aside'
  end
end
