# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.

class Page < ActiveRecord::Base
  belongs_to :user
  
  before_destroy :pop_descendents
  
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :published,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :draft,  lambda { |*limit| { :conditions => { :enabled => false }, :limit => limit.flatten.first } }
  named_scope :parentless, :conditions => { :parent_id => nil }
  named_scope :sub_page, lambda { |parent_id| { :conditions => { :parent_id => parent_id } } }
  
  acts_as_tree :order => "title"
  
  version_fu do
    belongs_to :user
  end
  
  validates_presence_of :title, :body
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
    
  def self.home
    enabled.find(:first, :conditions => { :home_page => true })
  end
  
  def self.home?
    home.present?
  end
  
  # Return the permalink with underscores and dashes split to spaces to allow better search.
  def permalink_with_spaces
    permalink.gsub(/["-"]/, ' ').gsub(/["_"]/, ' ')
  end
  
  # Check if a page is at the top of the tree
  def root?
    parent.nil?
  end
  
  # find all pages that have this page as a parent.
  def children
    self.class.find(:all, :conditions => { :parent_id => self.id })
  end
  
  def children?
    children.size > 0
  end
  
  # An alias for user
  def author
    user
  end
  
  #check if the page is the first to be created
  def first_page?
    self.class.count == 0
  end
  
  # Return the permalink as the page ID
  def to_param
    permalink_was
  end
  
  def draft?
    !published?
  end
  
  def published?
    enabled
  end
  
  def publish!
    update_attribute(:enabled, true)
  end
  
  def unpublish!
    update_attribute(:enabled, false)
  end
  
  private
  
  # TODO write test
  def pop_descendents
    children.each do |child|
      child.update_attribute(:parent_id, parent_id)
    end
  end
  
end
