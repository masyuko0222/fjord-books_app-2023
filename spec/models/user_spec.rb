# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    FactoryBot.reload
  end

  describe '#name_or_email' do
    context '名前を登録している場合' do
      it '名前を戻り値とする' do
        expect(FactoryBot.build(:user).name_or_email).to eq 'Alice'
      end
    end

    context 'Eメールアドレスしか登録していない場合' do
      it 'Eメールアドレスを戻り値とする' do
        user = FactoryBot.build(:user_without_name)

        expect(user.name_or_email).to eq 'tester1@example.com'
      end
    end
  end
end
