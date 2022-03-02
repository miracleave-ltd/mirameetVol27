require 'rails_helper'

RSpec.describe 'Devise', type: :request do
  let(:user_params) { attributes_for(:user) }
  describe 'registration' do
    describe 'GET #new' do
      it '200レスポンスを返すこと' do
        get new_user_registration_url
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'パラメータが妥当な場合' do
        subject { post user_registration_url, params: { user: user_params } }
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it 'ユーザーが登録されること' do
          expect{subject}.to change(User, :count).by(1)
        end

        it 'リダイレクトすること' do
          subject
          expect(response).to redirect_to root_url
        end
      end

      context 'パラメータが不正な場合' do
        subject { post user_registration_url, params: { user: attributes_for(:user, :invalid) } }
        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'ユーザーが登録されないこと' do
          expect{subject}.to_not change(User, :count)
        end

        it 'エラーが表示されること' do
          subject
          expect(response.body).to include 'エラーが発生したため ユーザー は保存されませんでした。'
        end
      end
    end
  end

  describe 'session' do
    describe 'GET #new' do
      it '200レスポンスを返すこと' do
        get new_user_session_url
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      let(:user_created_params) { attributes_for(:user) }
      let(:user) { User.create(user_created_params) }
      before do
        # 明示的にログアウトさせる
        sign_out user
      end
      context 'パラメータが妥当な場合' do
        subject { post user_session_url, params: { user: user_created_params } }
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it 'リダイレクトすること' do
          subject
          expect(response).to redirect_to root_url
        end
      end

      context 'パラメータが不正な場合' do
        subject { post user_session_url, params: { user: {email: nil, password: "I2nAj8H65j6E0p"} } }
        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'ログイン画面が表示されること' do
          subject
          expect(response.body).to include '<h2>Log in</h2>'
        end
      end
    end
  end
end
