module AboutHelper
  def search_result (item, query)
    result = highlight(item.title, @query) + '<br />'
    case item.type.to_s
      when "Blog"
        result += highlight(item.description, @query) + '<br />'
        result += link_to(highlight(item.slug, @query), item)
      when "Post"
        result += highlight(item.body, @query) + '<br />'
        result += link_to(highlight(item.slug, @query), [Blog.find(item.blog_id), item])
      else
        result += highlight(item.body, @query) + '<br />'
        result += link_to(highlight(item.slug, @query), item)
    end
    result
  end
end
