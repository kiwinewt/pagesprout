class Page < ActiveRecord::Base
  #acts_as_nested_set
  acts_as_tree :order => "title"
  version_fu
  
  validates_presence_of :title, :body
  validates_uniqueness_of :title, :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  #attr_accessor :child_of
  
  def self.all_top_level_pages
    Page.find(:all, :conditions => {:parent_id => 0})
  end
  
  def root?
    self.parent_id == 0 ? true : false
  end
  
  def self.children
    Page.find(:all, :conditions => {:parent_id => self.id})
  end
  
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
