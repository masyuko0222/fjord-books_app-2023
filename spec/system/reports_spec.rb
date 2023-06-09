require 'rails_helper'

RSpec.describe "Reports", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario 'ユーザーが新しい日報を書く' do
    user = FactoryBot.create(:user)

    visit root_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'

    expect {
      click_link '日報'
      click_link '日報の新規作成'
      fill_in 'タイトル', with: 'aaaa'
      fill_in '内容', with: 'bbbb'
      click_button '登録する'

      expect(page).to have_content '日報が作成されました。'
      expect(page).to have_content '日報の詳細'
      expect(page).to have_content 'タイトル: aaaa'
      expect(page).to have_content '内容: bbbb'
      expect(page).to have_content "作成者: #{user.name}"
      expect(page).to have_content "作成日: "
    }.to change(user.reports, :count).by(1)
  end
end
