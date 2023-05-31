# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should return email if name was not registed" do
    user = users(:no_name_has_email)

    assert_equal 'foo@example.com', user.name_or_email
  end

  test "should return name if name was registed" do
    user = users(:has_name_has_email)

    assert_equal 'bar', user.name_or_email
  end
end
