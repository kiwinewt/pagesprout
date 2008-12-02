# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class Post < ActiveRecord::Base
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :permalink_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  belongs_to :blog
  
  validates_presence_of :title, :body, :permalink
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/i
  
  # Return the permalink with underscores and dashes split to spaces to allow better search.
  def permalink_with_spaces
    return self.permalink.gsub('-', ' ').gsub('_', ' ')
  end
  
  # Return the permalink as the post ID
  def to_param
    permalink_was
  end
end
