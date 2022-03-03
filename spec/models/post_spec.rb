require 'rails_helper'

describe Post do
  let(:user) { create(:user, nickname: 'Takashi') }

  it 'text, userがあれば有効であること' do
    post = Post.new(
      text: '投稿のテキスト',
      user: user
    )
    expect(user).to be_valid
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :comments }
  end

  context 'text' do
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_length_of(:text).is_at_most(255) }
  end

  context 'image' do
    it 'url形式の場合、有効であること' do
      post = build(:post, image: 'http://www/example.com')
      expect(post).to be_valid
      post = build(:post, image: 'https://www/example.com')
      expect(post).to be_valid
    end

    it 'url形式以外の場合、無効な状態であること' do
      post = build(:post, image: 'example_not_url')
      post.valid?
      expect(post.errors[:image]).to include("は不正な値です") #invalid
    end
  end

  describe 'user_id' do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe '投稿機能' do
    context '#add_date_to_text' do
      it '意図した投稿内容になっていること' do
        post = create(:post, text: '投稿内容テスト')
        expect(post.text).to eq("投稿内容テスト :#{post.user.nickname}の投稿")
      end
    end

    context '#start_slack_sync' do
      before do
        allow(SlackSyncJobs).to receive(:perform_later)
      end
      it '保存した時にメソッドを呼び出していること' do
        post = create(:post)
        expect(SlackSyncJobs).to have_received(:perform_later).with(post.class.name, post.id)
      end
    end
  end
end
