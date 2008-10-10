class Post < ActiveRecord::Base

  belongs_to :blog
  
  validates_presence_of :title, :body, :slug
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
