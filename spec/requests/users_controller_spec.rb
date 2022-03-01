require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET #show' do
    context 'ユーザーが存在する場合' do
      let(:user) { create(:user, nickname: 'Takashi') }
      let!(:post) { create(:post, text: 'PostRequestTest', user: user)}
      subject { get user_path user.id }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'ユーザー名が表示されること' do
          subject
          expect(response.body).to include 'Takashi'
        end

        it 'レスポンスに適切な投稿内容を含むこと' do
          subject
          expect(response.body).to include 'PostRequestTest :Takashiの投稿'
          expect(response.body).to include '<span>投稿者</span>Takashi'
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

    context 'ユーザーが存在しない場合' do
      subject { get user_url 1 }
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
