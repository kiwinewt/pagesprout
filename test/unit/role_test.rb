require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  fixtures :users
  
  def test_should_create_role
    assert_difference 'Role.count' do
      role = create_role
      assert !role.new_record?, "#{role.errors.full_messages.to_sentence}"
    end
  end
  
  def test_user_should_have_role
    user = users(:quentin)
    assert_difference 'user.roles.count' do
      role = create_role
      user.roles << role
    end
  end

  protected
    def create_user(options = {})
      record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
      record.save
      record
    end
    
    def create_role(options = {})
      record = Role.new({ :rolename => 'quire' }.merge(options))
      record.save
      record
    end
end
