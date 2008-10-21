# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the user-created Pages in the site
module AboutHelper

  # This code allows specific linking/etc for items in the search results.
  # Add more details here if required. 
  def search_result (item, query)
    result = highlight(item.title, @query) + '<br />'
    case item.type.to_s
      when "Blog"
        result += highlight(item.description, @query) + '<br />'
        result += link_to(highlight(item.slug, @query), item)
      when "Post"
        result += highlight(item.body, @query) + '<br />'
        result += '<small>' + item.updated_at.strftime(AppConfig.date_string) + '</small><br />'
        result += link_to(highlight(item.slug, @query), [Blog.find(item.blog_id), item])
      else
        result += highlight(item.body, @query) + '<br />'
        result += link_to(highlight(item.slug, @query), item)
    end
    result
  end

end
