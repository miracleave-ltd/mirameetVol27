require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe '#create' do
    let(:user) { create(:user) }
    let(:post_instance) { create(:post, user: user) }
    subject {
      post :create,
      params: { post_id: post_instance.id, comment: attributes_for(:comment, post: post_instance, user: user) }
    }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context '有効な属性値の場合' do
        it 'コメントを追加できること' do
          expect { subject }.to change(user.comments, :count).by(1)
        end
      end

      context '無効な属性値の場合' do
        it 'コメントを追加できないこと' do
          expect {
            post :create,
            params: {
              post_id: post_instance.id,
              comment: attributes_for(:comment, :text_invalid, post: post_instance, user: user)
            }
          }.to_not change(user.comments, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスを返すこと' do
        subject
        expect(response.status).to eq 302
      end

      it 'ログイン画面にリダイレクトされること' do
        subject
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
