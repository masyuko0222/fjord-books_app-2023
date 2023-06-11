# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable? should return true when target user tries to edit a report created by target user' do
    target_user = FactoryBot.create(:user)
    report = FactoryBot.create(:report, user_id: target_user.id)

    assert report.editable?(target_user)
  end

  test '#editable? should return false when target user tries to edit a report created by another user' do
    target_user = FactoryBot.create(:user)
    another_user = User.create(email: 'bob@example.com', name: 'Bob', password: 'password')
    report = FactoryBot.create(:report, user_id: another_user.id)

    assert_not report.editable?(target_user)
  end
end
