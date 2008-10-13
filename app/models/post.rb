class Post < ActiveRecord::Base
  acts_as_ferret :fields => { :title => { :boost => 2 }, :body => {}, :slug_with_spaces => {} },
                 :remote => true,
                 :store_class_name => true
  belongs_to :blog
  
  validates_presence_of :title, :body, :slug
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /^[a-z0-9\-_]+$/i
  
  after_save :downcase_slug

  def slug_with_spaces
    return self.slug.gsub('-', ' ').gsub('_', ' ')
  end
  
  def to_param
    slug_was
  end
  
  private
  
  def downcase_slug
    slug.downcase!
  end
end
