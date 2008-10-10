class Blog < ActiveRecord::Base
  has_many :posts
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title, :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  def to_param
    slug_was
  end
  
  def enabled_posts_shortlist
    self.posts.find(:all, :conditions => { :enabled => true }, :limit => 10).reverse
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
