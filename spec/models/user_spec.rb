require 'rails_helper'

RSpec.describe User, type: :model do
  it "nickname, email, password, password_confirmationがあれば有効であること" do
    user = User.new(
      nickname: 'Takashi',
      email: 'tester@example.com',
      password: 'p@ssword!!',
      password_confirmation: 'p@ssword!!',
    )
    expect(user).to be_valid
  end

  describe 'アソシエーション' do
    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :comments }
  end

  describe 'nickname' do
    it { is_expected.to validate_presence_of :nickname }
    it { is_expected.to validate_uniqueness_of :nickname }
    it { is_expected.to validate_length_of(:nickname).is_at_most(10) }
  end

  describe 'email' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it 'emailの形式ではない場合、無効な状態であること' do
      user = build(:user, email: 'example_no_email')
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です") #invalid
    end

    it 'emailは全角文字を使用する場合、無効な状態であること' do
      user = build(:user, email: 'ｅｘａｐｌｅ@gmail.com')
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です") #invalid
    end
  end

  describe 'password' do
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
    it { is_expected.to validate_presence_of :password_confirmation }

    it 'passwordとpassword_confirmationが不一致の場合、無効な状態であること' do
      user = build(:user, password: 'password', password_confirmation: 'password_confirmation')
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません") #confirmation
    end
  end
end
