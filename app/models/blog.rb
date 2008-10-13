class Blog < ActiveRecord::Base
  has_many :posts
  
  acts_as_ferret :fields => { :title => { :boost => 2 }, :description => {}, :slug => {} },
                 :remote => true,
                 :store_class_name => true
  
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
