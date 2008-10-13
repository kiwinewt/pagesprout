module AboutHelper

  def search_result (item, query)
    # this code allows specific linking/etc for items in the search results.
    # add more details here if required
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
