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
    # shoulda-matchersを使用して、postモデルとのアソシエーションをテストする。
    # shoulda-matchersを使用して、commentモデルとのアソシエーションをテストする。
  end

  describe 'nickname' do
    it { is_expected.to validate_presence_of :nickname }
    it { is_expected.to validate_uniqueness_of :nickname }
    it { is_expected.to validate_length_of(:nickname).is_at_most(10) }
  end

  describe 'email' do
    # shoulda-matchersを使用して、emailが必須項目であることをテストする。
    # shoulda-matchersを使用して、emailがユニークであることをテストする。

    it 'emailの形式ではない場合、無効な状態であること' do
      # emailが正しい形式ではないuserインスタンスを作成して、無効であるかテストする。
    end

    it 'emailは全角文字を使用する場合、無効な状態であること' do
      # emailが全角入力のuserインスタンスを作成して、無効であるかテストする。
    end
  end

  describe 'password' do
    # shoulda-matchersを使用して、passwordが必須項目であることをテストする。
    # shoulda-matchersを使用して、passwordが6文字以上128文字以内で有効なことをテストする。
    # shoulda-matchersを使用して、password_confirmationが必須項目であることをテストする。

    it 'passwordとpassword_confirmationが不一致の場合、無効な状態であること' do
      # passwordの値とpassword_confirmationの値が一致しないuserインスタンスを作成して、無効であるかテストする。
    end
  end
end
