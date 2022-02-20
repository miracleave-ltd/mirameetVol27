require 'rails_helper'

describe Post do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }
  subject { post.save }

  describe 'validationテスト' do
    context '正常チェック' do
      it '保存できること' do
        is_expected.to eq(true)
      end
    end

    context 'text' do
      it 'nilの場合、保存できない' do
        post.text = nil
        is_expected.to eq(false)
      end

      it '空文字の場合、保存できない' do
        post.text = ""
        is_expected.to eq(false)
      end

      it '255文字以内の場合、保存できる' do
        post.text = Faker::Lorem.characters(number: 255)
        is_expected.to eq(true)
      end

      it '256文字以上の場合、保存できない' do
        post.text = Faker::Lorem.characters(number: 256)
        is_expected.to eq(false)
      end
    end

    context 'image' do
      it 'url形式の場合、保存できる' do
        post.image = Faker::Internet.url(scheme: 'http')
        is_expected.to eq(true)
        post.image = Faker::Internet.url(scheme: 'https')
        is_expected.to eq(true)
      end

      it 'url形式以外の場合、保存できない' do
        post.image = Faker::Lorem.word
        is_expected.to eq(false)
      end
    end

    context 'user_id' do
      it 'nilの場合、保存できない' do
        post.user_id = nil
        is_expected.to eq(false)
      end

      it '存在しないUserのidの場合、保存できない' do
        # TODO:存在しないUserのidの取得方法の検討
        post.user_id = User.maximum(:id) + 1
        is_expected.to eq(false)
      end
    end
  end

  describe '投稿機能' do
    context '#add_date_to_text' do
      it '意図した投稿内容になっているか' do
        post.text = "投稿内容テスト"
        subject
        expect(post.text).to eq("投稿内容テスト :#{post.user.nickname}の投稿")
      end
    end

    context '削除' do
      let!(:comment){ post.comments.build({text: "comment_text", user_id: user.id}) }
      it '投稿を削除した時、それに紐づくCommentも削除される' do
        subject
        expect{ post.destroy }.to change(Comment,:count).by(-1)
      end
    end
  end
end
