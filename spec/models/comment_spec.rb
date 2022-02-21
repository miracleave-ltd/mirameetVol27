require 'rails_helper'

describe Comment do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { build(:comment, user: user, post: post) }
  subject { comment.save }

  describe 'validationテスト' do
    context '正常チェック' do
      it '保存できること' do
        is_expected.to eq(true)
      end
    end

    context 'text' do
      it 'nilの場合、保存できない' do
        comment.text = nil
        is_expected.to eq(false)
      end

      it '空文字の場合、保存できない' do
        comment.text = ""
        is_expected.to eq(false)
      end

      it '100文字以内の場合、保存できる' do
        comment.text = Faker::Lorem.characters(number: 100)
        is_expected.to eq(true)
      end

      it '101文字以上の場合、保存できない' do
        comment.text = Faker::Lorem.characters(number: 101)
        is_expected.to eq(false)
      end
    end

    context 'user_id' do
      it 'nilの場合、保存できない' do
        comment.user_id = nil
        is_expected.to eq(false)
      end

      it '存在しないUserのidの場合、保存できない' do
        # TODO:存在しないUserのidの取得方法の検討
        comment.user_id = User.maximum(:id) + 1
        is_expected.to eq(false)
      end
    end

    context 'post_id' do
      it 'nilの場合、保存できない' do
        comment.post_id = nil
        is_expected.to eq(false)
      end

      it '存在しないPostのidの場合、保存できない' do
        # TODO:存在しないPostのidの取得方法の検討
        comment.post_id = Post.maximum(:id) + 1
        is_expected.to eq(false)
      end
    end
  end
end
