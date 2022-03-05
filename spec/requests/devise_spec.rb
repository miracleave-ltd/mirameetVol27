require 'rails_helper'

RSpec.describe 'Devise', type: :request do
  let(:user_params) { attributes_for(:user) }
  describe 'registration' do
    describe 'ユーザー新規登録画面表示機能' do
      subject { get new_user_registration_url }

      it_behaves_like 'return_response_status', 200
    end

    describe 'ユーザー新規作成機能' do
      context 'パラメータが妥当な場合' do
        subject { post user_registration_url, params: { user: user_params } }

        it_behaves_like 'return_response_status', 302

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

        it_behaves_like 'return_response_status', 200

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
    describe 'ユーザーログイン画面表示機能' do
      subject { get new_user_session_url }

      it_behaves_like 'return_response_status', 200
    end

    describe 'ユーザーログイン機能' do
      let(:user_created_params) { attributes_for(:user) }
      let(:user) { User.create(user_created_params) }
      before do
        sign_out user
      end

      context 'パラメータが妥当な場合' do
        subject { post user_session_url, params: { user: user_created_params } }

        it_behaves_like 'return_response_status', 302

        it 'リダイレクトすること' do
          subject
          expect(response).to redirect_to root_url
        end
      end

      context 'パラメータが不正な場合' do
        subject { post user_session_url, params: { user: {email: nil, password: "I2nAj8H65j6E0p"} } }

        it_behaves_like 'return_response_status', 200

        it 'ログイン画面が表示されること' do
          subject
          expect(response.body).to include '<h2>Log in</h2>'
        end
      end
    end
  end
end
