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

 describe 'nickname' do
  it 'nilの場合、無効であること' do
    # nicknameがnilのインスタンスを作成して、無効であることをテストする。
  end

  it '空文字の場合、無効であること' do
    # nicknameが「''」のインスタンスを作成して、無効であることをテストする。（無効な場合はエラー文が含まれているかテストする）
  end

  it 'すでに使用されているnicknameの場合、保存できないこと' do
    # 最初にuserインスタンスを保存する。
    # 次に最初に作成したuserインスタンスと同じnicknameを持ったuserインスタンスを新しく作成する。
    # そのインスタンスが無効であることをテストする。（無効な場合はエラー文が含まれているかテストする）
  end

  it '10文字以内の場合、有効であること' do
    # nicknameが10文字のuserインスタンスを作成し、有効であるかテストする。
  end

  it '11文字以上の場合、無効であること' do
    # nicknameが11文字のuserインスタンスを作成し、無効であるかテストする。（無効な場合はエラー文が含まれているかテストする）
  end
 end
end