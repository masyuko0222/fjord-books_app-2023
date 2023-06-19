# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email should return name if user has name' do
    user = FactoryBot.build(:user, name: 'Alice', email: 'alice@example.com')

    assert_equal 'Alice', user.name_or_email
  end

  test '#name_or_email should return email if user does not have name' do
    user = FactoryBot.build(:user, name: nil, email: 'alice@example.com')

    assert_equal 'alice@example.com', user.name_or_email
  end
end
