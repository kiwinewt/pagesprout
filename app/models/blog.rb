# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.
class Blog < ActiveRecord::Base
  has_many :posts
  
  named_scope :enabled, lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title, :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
    
  # Return the permalink as the blog ID
  def to_param
    permalink_was
  end

  # Return the permalink with underscores and dashes split to spaces to allow better search.
  def permalink_with_spaces
    return self.permalink.gsub(/["-"]/, ' ').gsub(/["_"]/, ' ')
  end
  
  # List latest 10 posts, ordered by date
  def enabled_posts_shortlist
    self.posts.enabled(10).reverse
  end
  
  def posts?
    posts.present?
  end
end
