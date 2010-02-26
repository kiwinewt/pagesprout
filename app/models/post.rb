# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
  
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :published,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  named_scope :draft,  lambda { |*limit| { :conditions => { :enabled => false }, :limit => limit.flatten.first } }
  
  validates_presence_of :title, :body, :permalink, :user, :blog
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
  
  attr_protected :permalink
  attr_writer :title
  
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
  
  def title=(name)
    write_attribute(:title, name)
    write_attribute(:permalink, (Time.now.strftime('%Y-%m-%d-') + name.gsub(/\s/, '-').gsub(/[^a-z0-9\-_]+/i, '')))
  end
end
