class Page < ActiveRecord::Base
  acts_as_paranoid
  version_fu
  
  validates_presence_of :title, :body
  validates_uniqueness_of :title, :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  # Acts as paranoid prevents using named_scope
  def self.deleted
    find_with_deleted(:all, :conditions => "deleted_at IS NOT NULL")
  end
  
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
