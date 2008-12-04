require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
  def setup
    ActionMailer::Base.default_url_options[:host] = "example.com"
  end

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_create_multiple_users
      user = create_user
      user = create_user(:login => 'fred', :email => 'fred@example.com')
      user = create_user(:login => 'bob', :email => 'bob@example.com')
      user = create_user(:login => 'dave', :email => 'dave@example.com')
      assert User.count == 7 # 4 users + 3 fixtures
  end

  def test_should_not_create_identical_users
    user = create_user
    assert_no_difference 'User.count' do
      user = create_user
      assert user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    user = create_user
    user.reload
    assert_not_nil user.activation_code
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_secure_password
    assert_no_difference 'User.count' do
      u = create_user(:password => 'hi', :password_confirmation => 'hi')
      assert u.errors.on(:password)
      u = create_user(:password => 'bob', :password_confirmation => 'bob')
      assert u.errors.on(:password)
      u = create_user(:password => 'a', :password_confirmation => 'a')
      assert u.errors.on(:password)
      u = create_user(:password => '', :password_confirmation => '')
      assert u.errors.on(:password)
      u = create_user(:password => '123', :password_confirmation => '123')
      assert u.errors.on(:password)
    end
    u = create_user(:password => 'helloworld', :password_confirmation => 'helloworld')
    assert !u.errors.on(:password)
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
      u = create_user(:email => 'hi')
      assert u.errors.on(:email)
      u = create_user(:email => 'abc@123')
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.save
    record
  end
end
