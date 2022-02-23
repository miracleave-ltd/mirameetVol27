require 'rails_helper'

describe User do
  let(:user) { build(:user) }
  subject { user.save }

  describe 'validationテスト' do
    context '正常チェック' do
      it '保存できること' do
        is_expected.to eq(true)
      end
    end

    context 'nickname' do
      it 'nilの場合、保存できない' do
        user.nickname = nil
        is_expected.to eq(false)
      end

      it '空文字の場合、保存できない' do
        user.nickname = ""
        is_expected.to eq(false)
      end

      it '10文字以内の場合、保存できる' do
        user.nickname = Faker::Lorem.unique.characters(number: 10)
        is_expected.to eq(true)
      end

      it '11文字以上の場合、保存できない' do
        user.nickname = Faker::Lorem.unique.characters(number: 11)
        is_expected.to eq(false)
      end

      it 'すでに使用されているnicknameの場合、保存できない' do
        subject
        next_user = build(:user, nickname: user.nickname)
        expect(next_user.save).to eq(false)
      end
    end

    context 'email' do
      it 'nilの場合、保存できない' do
        user.email = nil
        is_expected.to eq(false)
      end

      it '空文字の場合、保存できない' do
        user.email = ""
        is_expected.to eq(false)
      end

      it 'emailの形式ではない場合、保存できない' do
        user.email = Faker::Lorem.sentence
        is_expected.to eq(false)
      end

      it '全角文字を使用する場合、保存できない' do
        user.email = 'ｅｘａｐｌｅ@gmail.com'
        is_expected.to eq(false)
      end

      it 'すでに使用されているemailの場合、保存できない' do
        subject
        next_user = build(:user, email: user.email)
        expect(next_user.save).to eq(false)
      end
    end

    context 'password' do
      it 'passwordがnilの場合、保存できない' do
        user.password = nil
        is_expected.to eq(false)
      end

      it 'passwordが空文字の場合、保存できない' do
        user.password = ""
        is_expected.to eq(false)
      end

      it 'password_confirmationがnilの場合、保存できない' do
        user.password_confirmation = nil
        is_expected.to eq(false)
      end

      it 'password_confirmationが空文字の場合、保存できない' do
        user.password_confirmation = ""
        is_expected.to eq(false)
      end

      it 'passwordとpassword_confirmationが不一致の場合、保存できない' do
        user.password = 'password'
        user.password_confirmation = 'password_confirmation'
        is_expected.to eq(false)
      end

      it '5文字以下の場合、保存できない' do
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 5)
        is_expected.to eq(false)
      end

      it '6文字以上、128文字以下の場合、保存できる' do
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 6)
        is_expected.to eq(true)
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 128)
        is_expected.to eq(true)
      end

      it '129文字以上の場合、保存できない' do
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 129)
        is_expected.to eq(false)
      end
    end
  end
end
