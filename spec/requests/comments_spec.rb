require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:post_instance) { create(:post, user: user) }

  describe 'POST #create' do
    subject {
      post post_comments_url post_instance,
      params: { comment: attributes_for(:comment, post: post_instance) }
    }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context 'パラメータが妥当な場合' do
        it_behaves_like 'return_response_status', 302

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
          params: { comment: attributes_for(:comment, :text_invalid, post: post_instance) }
        }

        it_behaves_like 'return_response_status', 302

        it 'コメントが登録されないこと' do
          expect{subject}.to_not change(Comment, :count)
        end

        it 'エラーが表示されること' do
          post post_comments_url(post_instance),
          xhr: true,
          params: { comment: attributes_for(:comment, :text_invalid, post: post_instance) }
          expect(response.body).to include 'Textを入力してください'
        end
      end
    end

    it_behaves_like 'ログインしていない場合'
  end
end
