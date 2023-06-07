# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  before do
    FactoryBot.reload
  end

  describe '#edit_able?' do
    context 'ログインしているユーザーが、レポートの作成者の場合' do
      it 'trueを戻り値とする' do
        user = FactoryBot.create(:user)
        report = FactoryBot.create(:report, user:)

        expect(report.editable?(user)).to be_truthy
      end
    end

    context 'ログインしているユーザーが、レポートの作成者ではない場合' do
      it 'falseを戻り値とする' do
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        report = FactoryBot.create(:report, user: other_user)

        expect(report.editable?(user)).to be_falsey
      end
    end
  end

  describe '#created_on' do
    it 'created_atをDateオブジェクトに変換する' do
      report = FactoryBot.create(:report)

      expect(report.created_on.class).to eq Date
    end
  end

  describe '#save_mentions called after save' do
    context '日報を新規作成する場合' do
      context '正常な日報URIのみに対して言及すると' do
        it '言及した日報全てをメンション関係に追加する' do
          report = FactoryBot.create(:report, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good!")
          mentioning_report_2 = FactoryBot.create(:report, id: 2)
          mentioning_report_3 = FactoryBot.create(:report, id: 3)

          report.save

          expect(report.mentioning_report_ids).to eq [2,3]
        end
      end

      context '異常な日報URIも含めて言及すると' do
        it '正常な日報URIのみをメンション関係に追加する' do
          report = FactoryBot.create(:report, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/ijou is ijou. http://localhost:3000/reports/７７７ is zenkaku. http://localhost:3000/reports/290971 is not exist.")
          mentioning_report_2 = FactoryBot.create(:report, id: 2)
          mentioning_report_3 = FactoryBot.create(:report, id: 3)

          report.save

          expect(report.mentioning_report_ids).to eq [2,3]
        end
      end

      context '自身の日報URIも含めて言及すると' do
        it '自身の日報URIは除外してメンション関係に追加する' do
          report = FactoryBot.create(:report, id: 1, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/1 is me.")
          mentioning_report_2 = FactoryBot.create(:report, id: 2)
          mentioning_report_3 = FactoryBot.create(:report, id: 3)

          report.save

          expect(report.mentioning_report_ids).to eq [2,3]
        end
      end
    end

#    context '日報を更新する場合' do
#    end
  end
end
