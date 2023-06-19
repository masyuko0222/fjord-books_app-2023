# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report1 = FactoryBot.create(:report)
    @report2 = FactoryBot.create(:report)
    @report3 = FactoryBot.create(:report)
    @report4 = FactoryBot.create(:report)
  end

  test '#editable? should return true when target user tries to edit a report created by target user' do
    target_user = FactoryBot.create(:user)
    report = FactoryBot.create(:report, user: target_user)

    assert report.editable?(target_user)
  end

  test '#editable? should return false when target user tries to edit a report created by another user' do
    target_user = FactoryBot.create(:user)
    another_user = FactoryBot.create(:user, email: 'bob@example.com', name: 'Bob')
    report = FactoryBot.create(:report, user: another_user)

    assert_not report.editable?(target_user)
  end

  test '#created_on should convert created_at that is attribute of Report to Date object' do
    report = FactoryBot.create(:report, created_at: Time.zone.parse('2023-01-01'))

    assert_equal Date.new(2023, 1, 1), report.created_on
  end

  test '#save_mentions should save new mentioning relationships after saving when a new report is created with mentions' do
    report = FactoryBot.create(:report, content: <<~TEXT)
      http://localhost:3000/reports/#{@report1.id} is good.
      http://localhost:3000/reports/#{@report2.id} is bad."
    TEXT

    assert_equal [@report1, @report2], report.mentioning_reports
  end

  test '#save_mentions should destory exisiting mentioning relationships and save new mentioning relationships after saving when a report is updated' do
    report = FactoryBot.create(:report, content: <<~TEXT)
      http://localhost:3000/reports/#{@report1.id} is good.
      http://localhost:3000/reports/#{@report2.id} is bad.
    TEXT

    assert_equal [@report1, @report2], report.mentioning_reports

    report.update(content: <<~TEXT)
      http://localhost:3000/reports/#{@report3.id} is good.
      http://localhost:3000/reports/#{@report4.id} is bad.
    TEXT

    assert_equal [@report3, @report4], report.reload.mentioning_reports
  end

  test '#save_mentions should save new mentioning relationships without mention to reportself after saving' do
    report = FactoryBot.create(:report)

    report.update(content: <<~TEXT)
      http://localhost:3000/reports/#{@report1.id} is good.
      http://localhost:3000/reports/#{@report2.id} is bad.
      http://localhost:3000/reports/#{report.id} is me.
    TEXT

    assert_equal [@report1, @report2], report.mentioning_reports
  end
end
