# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class Post < ActiveRecord::Base
  named_scope :enabled,  lambda { |*limit| { :conditions => { :enabled => true }, :limit => limit.flatten.first } }
  
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :slug_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  belongs_to :blog
  
  validates_presence_of :title, :body, :slug
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug

  # Return the slug with underscores and dashes split to spaces to allow better search.
  def slug_with_spaces
    return self.slug.gsub('-', ' ').gsub('_', ' ')
  end
  
  # Return the slug as the post ID
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
