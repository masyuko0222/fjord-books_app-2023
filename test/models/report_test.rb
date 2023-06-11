# frozen_string_literal: true

require 'test_helper'
require 'debug'

class ReportTest < ActiveSupport::TestCase
  setup do
    FactoryBot.create(:report, id: 10)
    FactoryBot.create(:report, id: 11)
    FactoryBot.create(:report, id: 12)
    FactoryBot.create(:report, id: 13)
  end

  test '#editable? should return true when target user tries to edit a report created by target user' do
    target_user = FactoryBot.create(:user)
    report = FactoryBot.create(:report, user: target_user)

    assert report.editable?(target_user)
  end

  test '#editable? should return false when target user tries to edit a report created by another user' do
    target_user = FactoryBot.create(:user)
    another_user = User.create(email: 'bob@example.com', name: 'Bob', password: 'password')
    report = FactoryBot.create(:report, user: another_user)

    assert_not report.editable?(target_user)
  end

  test '#created_on should convert created_at that is attribute of Report to Date object' do
    report = FactoryBot.create(:report)

    assert_equal Date, report.created_on.class
  end

  test '#save_mentions should save new mentioning relationships after saving when a new report is created with mentions' do
    report = FactoryBot.build(:report)
    report.content = 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad.'
    report.save

    assert_equal [10, 11], report.mentioning_report_ids
  end

  test '#save_mentions should destory exisiting mentioning relationships and save new mentioning relationships after saving when a report is updated' do
    report = FactoryBot.create(:report, content: 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad.')

    assert_equal [10, 11], report.mentioning_report_ids

    report.update(content: 'http://localhost:3000/reports/12 is good. http://localhost:3000/reports/13 is bad.')

    assert_equal [12, 13], report.reload.mentioning_report_ids
  end

  test '#save_mentions should save new mentioning relationships without mention to reportself after saving' do
    # rubucop対策のため、ここだけcontentを別で定義
    content_mentioning_reportself = 'http://localhost:3000/reports/10 is good. http://localhost:3000/reports/11 is bad. http://localhost:3000/reports/99 is me.'
    report = FactoryBot.create(:report, id: 99, content: content_mentioning_reportself)

    assert_equal [10, 11], report.mentioning_report_ids
  end
end
