# Author::    Kiwinewt.Geek  (mailto: kiwinewt at kiwinewt dot geek dot nz)
# Copyright:: Copyright (c) 2010 Kiwinewt.Geek Ltd
# License::   BSD Licence, see application root.
class Role < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  
  def name
    rolename
  end
end
