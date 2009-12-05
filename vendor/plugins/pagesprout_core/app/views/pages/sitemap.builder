xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  if @home_page
    xml.url do
      xml.loc page_url(@home_page)
      xml.priority "1.0"
      xml.lastmod @home_page.updated_at.to_date
    end
  else
    xml.url do
      xml.loc root_url
      xml.priority "1.0"
      xml.lastmod Time.now
    end
  end
  @pages.each do |entry|
    xml.url do
      xml.loc page_url(entry)
      xml.priority "0.9"
      xml.lastmod entry.updated_at.to_date
    end
  end
  @blogs.each do |entry|
    xml.url do
      xml.loc blog_url(entry)
      xml.changefreq "daily"
      xml.priority "0.9"
      xml.lastmod entry.updated_at.to_date
    end
    Post.find(:all, :conditions => { :enabled => true, :blog_id => entry.id }, :order => "updated_at DESC", :limit => 500).each do |post|
      xml.url do
        xml.loc blog_post_url(entry,post)
        xml.priority "0.5"
        xml.lastmod entry.updated_at.to_date
      end
    end
  end
end

