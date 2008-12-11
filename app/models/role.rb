# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.
class Role < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  
  def name
    rolename
  end
end
