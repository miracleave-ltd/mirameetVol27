require 'rails_helper'

describe Post do
  let(:user) { create(:user) }
  let(:post) { build(:post, user_id: user.id) }

  context 'validationテスト' do
    it '正常チェック' do
      expect(post.save).to be_truthy
    end

    it 'textは必須' do
      post.text = nil
      expect(post.save).to be_falsey
      post.text = ""
      expect(post.save).to be_falsey
    end

    it 'textは255文字以内で保存できる' do
      post.text = Faker::Lorem.characters(number: 255)
      expect(post.save).to be_truthy
    end

    it 'textは256文字以上で保存できない' do
      post.text = Faker::Lorem.characters(number: 256)
      expect(post.save).to be_falsey
    end

    it 'imageはurl形式で保存できる' do
      post.image = Faker::Internet.url(scheme: 'http')
      expect(post.save).to be_truthy
      post.image = Faker::Internet.url(scheme: 'https')
      expect(post.save).to be_truthy
    end

    it 'imageはurl形式以外で保存できない' do
      post.image = Faker::Lorem.word
      expect(post.save).to be_falsey
    end
  end

  context '投稿内容' do
    it '投稿が意図した内容で保存される' do
      post.text = "投稿内容テスト"
      post.save
      expect(post.text).to eq("投稿内容テスト :#{post.user.nickname}の投稿")
    end
  end
end
