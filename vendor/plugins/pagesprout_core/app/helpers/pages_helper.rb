# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Pages in the site
module PagesHelper
  
  # Sets the page's title and displays the heading.
  # You can choose to hide the title in the view by changing the <tt>&lt;%=</tt> prefix to <tt>&lt;%</tt>.
  def page_heading(text)
    content_for(:title){ text }
    content_tag(:h1, text)
  end
  
  # Returns the complete title of the page, to be used inside the title tags.
  def page_title
    (@content_for_title + " &mdash; " if @content_for_title).to_s + AppConfig.site_name
  end
  
  # This adds recaptcha tags to the page if the API key has been added
  def add_recaptcha_tags
    result = ""
    if !AppConfig.recaptcha_public_key.blank? && !AppConfig.recaptcha_private_key.blank?
      result = '<div class="element" id="recaptcha">'
      result +=  recaptcha_tags
      result += '</div>'
    end
    result
  end
end
