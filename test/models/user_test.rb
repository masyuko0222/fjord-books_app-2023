# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email returns name if a user has name' do
    user = User.new(email: 'alice@example.com', name: 'Alice')

    assert_equal 'Alice', user.name_or_email
  end

  test '#name_or_email returns email if a user does not have name' do
    user = User.new(email: 'alice@example.com', name: nil)
    assert_equal 'alice@example.com', user.name_or_email
  end
end
