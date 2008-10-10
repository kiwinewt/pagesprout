class Page < ActiveRecord::Base
  acts_as_nested_set
  version_fu
  
  validates_presence_of :title, :body
  validates_uniqueness_of :title, :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  attr_accessor :child_of
  
  def self.all_top_level_pages
    Page.find(:all, :conditions => "parent_id IS NULL")
  end
  
  def self.reorder_siblings(siblings)

    index = 0
    @parent = nil
    last_child = nil

    # Heres were most of the work is done
    siblings.each do |child|
      this_child = Page.find(child)
      
      # If last child is nil, then we know that we are dealing with the first item
      # in the array
      if(last_child.nil?)
          last_child ||= this_child
      else
        # If we are here the we know that we need to take this child and 
        # move it to the right of the last child
          this_child.move_to_right_of last_child
          last_child = this_child
      end
    end
  end
  
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
    self.instatiate_revision
  end
end
