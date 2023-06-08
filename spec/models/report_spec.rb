# frozen_string_literal: true

require 'rails_helper'
require 'debug'

RSpec.describe Report, type: :model do
  before do
    FactoryBot.reload
  end

  let(:user) { FactoryBot.create(:user) }
  let(:report) { FactoryBot.create(:report, user:) }

  describe '#edit_able?' do
    context 'ログインしているユーザーが、レポートの作成者の場合' do
      it 'trueを戻り値とする' do
        expect(report.editable?(user)).to be_truthy
      end
    end

    context 'ログインしているユーザーが、レポートの作成者ではない場合' do
      it 'falseを戻り値とする' do
        other_user = FactoryBot.create(:user, :other_user)
        report_created_by_other_user = FactoryBot.create(:report, user: other_user)

        expect(report_created_by_other_user.editable?(user)).to be_falsey
      end
    end
  end

  describe '#created_on' do
    it 'created_atをDateオブジェクトに変換する' do
      expect(report.created_on.class).to eq Date
    end
  end

  describe '#save_mentions called after save' do
    let!(:mentioning_report_2) { FactoryBot.create(:report, id:2) }
    let!(:mentioning_report_3) { FactoryBot.create(:report, id:3) }

    context '日報を新規作成する場合' do
      it '正常な日報URIのみに対して言及すると、言及した日報全てをメンション関係に追加する' do
        report = FactoryBot.build(:report, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good!")

        report.save

        expect(report.mentioning_report_ids).to eq [2,3]
      end

      it '異常な日報URIも含んで言及すると、正常な日報URIのみをメンション関係に追加する' do
        non_exist_report_id = (Report.last.id).to_i + 1

        report = FactoryBot.build(:report, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/ijou is string. http://localhost:3000/reports/７７７ is zenkaku. http://localhost:3000/reports/#{non_exist_report_id} is not exist.")

        report.save

        expect(report.mentioning_report_ids).to eq [2,3]
      end

      it '自身の日報URIも含めて言及すると、自身の日報URIは除外してメンション関係に追加する' do
        # 今後letでreportのセットアップをしてもreport_idが重複しないよう、idに100を振る。
        report_mentioning_self = FactoryBot.build(:report, id: 100, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/100 is me.")

        report_mentioning_self.save

        expect(report_mentioning_self.mentioning_report_ids).to eq [2,3]
      end
    end

    context '日報を更新する場合' do
      it '既存のメンション関係を全て削除後、新しいメンション関係を追加する' do
        report = FactoryBot.create(:report, content: "http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good!")

        expect{ report.update(content: 'No mentions') }.to change{ report.mentioning_reports.count }.from(2).to(0)
      end
    end
  end
end
