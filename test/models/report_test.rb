# frozen_string_literal: true

require 'test_helper'
require 'debug'

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

  test '#created_on should convert created_at that is attribute of Report to Date object' do
    report = FactoryBot.create(:report)

    assert_equal Date, report.created_on.class
  end

  test '#save_mentions should save new mentioning relationships after saving when a new report is created with mentions' do
    report10 = FactoryBot.create(:report, id: 10)
    report11 = FactoryBot.create(:report, id: 11)

    report = FactoryBot.build(:report)
    report.content = 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad.'
    report.save

    assert_equal [10, 11], report.mentioning_report_ids
  end

  test '#save_mentions should destory exisiting mentioning relationships and save new mentioning relationships after saving when a report is updated' do
    report10 = FactoryBot.create(:report, id: 10)
    report11 = FactoryBot.create(:report, id: 11)

    report12 = FactoryBot.create(:report, id: 12)
    report13 = FactoryBot.create(:report, id: 13)

    report = FactoryBot.create(:report, content: 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad.')

    new_content = 'http://localhost:3000/reports/12 is good. http://localhost:3000/reports/13 is bad.'
    report.update(content: new_content)

    assert_equal [12, 13], report.reload.mentioning_report_ids
  end

  test '#save_mentions should save new mentioning relationships without mention to reportself after saving' do
    report10 = FactoryBot.create(:report, id: 10)
    report11 = FactoryBot.create(:report, id: 11)

    report = FactoryBot.create(:report, id: 100, content: 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad. http://localhost:3000/reports/100 is me.')

    assert_equal [10, 11], report.mentioning_report_ids
  end
end
