# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Pages in the site
module PagesHelper
  
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
