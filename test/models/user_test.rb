# frozen_string_literal: true

require "test_helper"
require "minitest/autorun"

class UserTest < ActiveSupport::TestCase
  describe '#name_or_email' do
    it 'returns name if user has name' do
      user = User.new(email: 'alice@example.com', name: 'alice')

      assert_equal 'alice', user.name_or_email
    end

    it 'returns email if user dose not have name' do
      user = User.new(email: 'alice@example.com', name: '')

      assert_equal 'alice@example.com', user.name_or_email
    end
  end
end
