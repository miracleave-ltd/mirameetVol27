require 'rails_helper'

RSpec.describe 'CommentsController', type: :request do
  let(:user) { create(:user, nickname: 'Takashi') }
  let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }

  describe 'POST #create' do
    subject {
      post post_comments_url post_instance,
      params: { comment: attributes_for(:comment) }
    }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context 'パラメータが妥当な場合' do
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it 'コメントが登録されること' do
          expect do
            subject
          end.to change(Comment, :count).by(1)
        end

        it '投稿詳細画面にリダイレクトすること' do
          subject
          expect(response).to redirect_to post_url post_instance
        end
      end

      context 'パラメータが不正な場合' do
        subject {
          post post_comments_url post_instance,
          params: { comment: attributes_for(:comment, :text_invalid) }
        }
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it 'コメントが登録されないこと' do
          expect{subject}.to_not change(Comment, :count)
        end

        it 'エラーが表示されること' do
          post post_comments_url(post_instance),
          xhr: true,
          params: { comment: attributes_for(:comment, :text_invalid) }

          expect(response.body).to include 'Textを入力してください'
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it '302レンスポンスを返すこと' do
        subject
        expect(response.status).to eq 302
      end

      it 'ログイン画面にリダイレクトされること' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
