require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "#edit_able?" do
    context "ログインしているユーザーが、レポートの作成者の場合" do
      it "trueを戻り値とする" do
        user = FactoryBot.create(:user)
        report = FactoryBot.create(:report, user: user)

        expect(report.editable?(user)).to be_truthy
      end
    end

    context "ログインしているユーザーが、レポートの作成者ではない場合" do
      it "falseを戻り値とする" do
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        report = FactoryBot.create(:report, user: other_user)

        expect(report.editable?(user)).to be_falsey
      end
    end
  end
end
