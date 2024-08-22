# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    auth = Struct.new(:provider, :uid, :info)
    info = Struct.new(:email)
    @auth = auth.new(
      provider: 'github',
      uid: '123456',
      info: info.new(email: 'auth@example.com')
    )
  end

  test 'name_or_email' do
    user = users(:komagata)
    assert_equal '駒形 真幸', user.name_or_email

    user.name = ''
    assert_equal 'komagata@example.com', user.name_or_email
  end

  test 'find_or_create_from_omniauth #find' do
    exist_user = User.create!(provider: 'github', uid: '123456', email: 'existing@example.com', password: 'password')
    user = User.find_or_create_from_omniauth(@auth)

    assert_equal exist_user, user
  end

  test 'find_or_create_from_omniauth #create' do
    assert_difference 'User.count', 1 do
      user = User.find_or_create_from_omniauth(@auth)

      assert_equal 'github', user.provider
      assert_equal '123456', user.uid
      assert_equal 'auth@example.com', user.email
    end
  end
end
