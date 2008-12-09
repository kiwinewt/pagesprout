# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
  
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :published,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :draft,  lambda { |*limit| { :conditions => { :enabled => false }, :limit => limit.flatten.first } }
  
  before_validation :generate_permalink
  
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :permalink_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  
  validates_presence_of :title, :body, :permalink, :user
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
  
  attr_protected :permalink
  
  # Return the permalink with underscores and dashes split to spaces to allow better search.
  def permalink_with_spaces
    return self.permalink.gsub(/[\-_]+/, ' ')
  end
  
  def toggle_enabled!
    self.enabled = !self.enabled
    save
  end
  
  def published?
    enabled
  end
  
  # Return the permalink as the post ID
  def to_param
    permalink_was
  end
  
  private
    
  def generate_permalink
    permalink = (Time.now.strftime('%Y-%m-%d-') + title.gsub(/\s/, '-').gsub(/[^a-z0-9\-_]+/i, ''))[0..50].downcase!
  end
end
