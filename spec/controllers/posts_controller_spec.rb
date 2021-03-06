require 'rails_helper'

RSpec.describe PostsController, type: :controller do  
  let(:user) { create(:user) }  
  describe '#indexアクションテスト' do
    subject { get :index }
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

  describe '#newアクションテスト' do
    subject { get :new }
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

  describe '#createアクションテスト' do    
    subject { post :create, params: { post: { image: 'https://example_image_url', text: 'PostRequestTest' } } }
    context 'ログインしている場合' do
      before do
        sign_in user        
      end

      it '302レスポンスを返すこと' do
        subject
        expect(response.status).to eq 302
      end

      it '投稿一覧画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to posts_path
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログイン画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe '#destroyアクションテスト' do
    let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }
    subject { delete :destroy, params: { id: post_instance.id } }
    context 'ログインしている場合' do
      before do
        sign_in user
        post_instance          
      end

      it '302レスポンスを返すこと' do          
        subject
        expect(response.status).to eq 302
      end

      it '投稿一覧画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to posts_path
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログイン画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe '#editアクションテスト' do
    let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }
    subject { get :edit, params: { id: post_instance.id } }
    context '投稿編集' do
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

  describe '#updateアクションテスト' do
    let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }
    subject {
      patch :update, 
        params: { 
          id: post_instance.id, 
          post: { image: post_instance.image, text: post_instance.text }
        }
    }
    context 'ログインしている場合' do
      before do
        sign_in user        
      end

      it '302レスポンスを返すこと' do          
        subject
        expect(response.status).to eq 302
      end

      it '投稿一覧画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to posts_path
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログイン画面にリダイレクトされること' do          
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe '#showアクションテスト' do
    let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }
    subject { post :show, params: { id: post_instance.id } }
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