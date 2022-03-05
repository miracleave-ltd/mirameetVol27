require 'rails_helper'

describe Comment do
  let(:post) { create(:post) }

  it 'text, user_id, post_idがあれば有効であること' do
    comment = Comment.new(
      text: 'comment_text',
      user_id: post.user.id,
      post_id: post.id
    )
    expect(comment).to be_valid
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :post }
  end

  describe 'text' do
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_length_of(:text).is_at_most(100) }
  end

  describe 'user_id' do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'post_id' do
    it { is_expected.to validate_presence_of(:post) }
  end
end
