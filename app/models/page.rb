# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class Page < ActiveRecord::Base
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :parentless, :conditions => { :parent_id => 0, :home_page => false }
  
  acts_as_tree :order => "title"
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :slug_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  version_fu
  
  validates_presence_of :title, :body
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug
  
  def self.home
    enabled.find(:first, :conditions => { :home_page => true })
  end
  
  def self.home?
    home.present?
  end

  # Return the slug with underscores and dashes split to spaces to allow better search.
  def slug_with_spaces
    return self.slug.gsub(/["-"]/, ' ').gsub(/["_"]/, ' ')
  end
  
  # Check if a page is at the top of the tree
  def root?
    self.parent_id == 0 ? true : false
  end
  
  # find all pages that have this page as a parent.
  def children
    self.class.find(:all, :conditions => { :parent_id => self.id })
  end
  
  # Return the slug as the page ID
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
