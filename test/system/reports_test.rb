# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    @user = FactoryBot.create(:user, email: 'alice@example.com')
    login_as(@user)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'create a new report' do
    visit new_report_url
    fill_in 'タイトル', with: 'First report'
    fill_in '内容', with: 'はじめまして'
    click_button '登録する'

    assert_text '日報が作成されました'
    assert_text 'First report'
    assert_text 'はじめまして'
    assert_text "作成者: #{@user.name}"
  end

  test 'update a report' do
    report = FactoryBot.create(:report, user: @user)

    visit edit_report_url(report.id)
    fill_in 'タイトル', with: 'アップデートしてみました'
    fill_in '内容', with: 'アップデートをした文章です。'
    click_button '更新する'

    assert_text '日報が更新されました'
    assert_text 'アップデートしてみました'
    assert_text 'アップデートをした文章です。'
    assert_text "作成者: #{@user.name}"
  end

  test 'destory a report' do
    report = FactoryBot.create(:report, user: @user, title: '削除予定です', content: '削除をする日報です。')

    visit report_url(report.id)

    assert_text '削除予定です'
    assert_text '削除をする日報です。'

    click_button 'この日報を削除'

    assert_no_content '削除予定です'
    assert_text '日報が削除されました。'
    assert_current_path reports_path
    assert_not Report.exists?(report.id)
  end
end
