require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#showアクションテスト' do
    context 'ユーザが存在する場合' do
      let(:user) { create(:user) }
      subject { get :show, params: { id: user.id } }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it '正常にレスポンスを返すこと' do
          subject
          expect(response).to be_successful
        end
      end

      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it '302レスポンスを返すこと' do
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
end