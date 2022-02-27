require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET #show' do
    context 'ユーザーが存在する場合' do
      let(:user) { create(:user, nickname: 'Takashi') }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it 'リクエストが成功すること' do
          get user_path user.id
          expect(response.status).to eq 200
        end

        it 'ユーザー名が表示されること' do
          get user_path user.id
          expect(response.body).to include 'Takashi'
        end
      end

      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it 'リクエストが成功しないこと' do
          get user_path user.id
          expect(response.status).to eq 302
        end
      end
    end

    context 'ユーザーが存在しない場合' do
      it 'リクエストが成功しないこと' do
        get user_url 1
        expect(response.status).to eq 302
      end
    end
  end
end
