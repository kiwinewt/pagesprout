# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class Blog < ActiveRecord::Base
  has_many :posts
  
  named_scope :enabled, lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  
  acts_as_ferret :fields => { :title => { :boost => 2 }, :description => {}, :slug_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title, :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  # Return the slug as the blog ID
  def to_param
    slug_was
  end

  # Return the slug with underscores and dashes split to spaces to allow better search.
  def slug_with_spaces
    return self.slug.gsub(/["-"]/, ' ').gsub(/["_"]/, ' ')
  end
  
  # List latest 10 posts, ordered by date
  def enabled_posts_shortlist
    self.posts.enabled(10).reverse
  end
  
  private
  
    def downcase_slug
      slug.downcase!
    end
end
