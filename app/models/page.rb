# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

class Page < ActiveRecord::Base
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true, :home_page => false }, :limit => limit.flatten.first } }
  named_scope :parentless, :conditions => { :parent_id => 0 }
  named_scope :sub_page, lambda { |parent_id| { :conditions => { :parent_id => parent_id } } }
  
  acts_as_tree :order => "title"
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :permalink_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  version_fu
  
  validates_presence_of :title, :body
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
    
  def self.home
    parentless.find(:first, :conditions => { :home_page => true, :enabled => true })
  end
  
  def self.home?
    home.present?
  end
  
  # Return the permalink with underscores and dashes split to spaces to allow better search.
  def permalink_with_spaces
    return self.permalink.gsub(/["-"]/, ' ').gsub(/["_"]/, ' ')
  end
  
  # Check if a page is at the top of the tree
  def root?
    self.parent_id == 0 ? true : false
  end
  
  # find all pages that have this page as a parent.
  def children
    self.class.find(:all, :conditions => { :parent_id => self.id })
  end
  
  #check if the page is the first to be created
  def first_page?
    pages = Page.all.length
    if pages == 0
      true
    else
      false
    end
  end
  
  # Return the permalink as the page ID
  def to_param
    permalink_was
  end
end
