require 'rails_helper'

RSpec.describe 'PostsControllers', type: :request do
  let(:user) { create(:user, nickname: 'Takashi') }
  let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }

  describe 'GET #index' do
    subject { get posts_url }

    context 'ログインしている場合' do
      before do
        sign_in user
        post_instance
      end

      it '200レスポンスを返すこと' do
        subject
        expect(response.status).to eq 200
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

  describe 'GET #show' do
    context '投稿が存在する場合' do
      subject { get post_url post_instance.id }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'レスポンスに適切な投稿とコメント表示欄を含むこと' do
          subject
          expect(response.body).to include 'PostRequestTest :Takashiの投稿'
          expect(response.body).to include '<span>投稿者</span>Takashi'
          expect(response.body).to include '<h4><コメント一覧></h4>'
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

    # TODO:skip
    context '投稿が存在しない場合' do
      before do
        sign_in user
      end

      xit 'ログイン画面にリダイレクトされること' do
        get post_url 1
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #new' do
    subject { get new_post_url }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200レスポンスを返すこと' do
        subject
        expect(response.status).to eq 200
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

  describe 'POST #create' do
    context 'ログインしている場合' do
      subject { post posts_url, params: { post: attributes_for(:post, :image_present) } }
      before do
        sign_in user
      end

      context 'パラメータが妥当な場合' do
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it '投稿が登録されること' do
          expect do
            subject
          end.to change(Post, :count).by(1)
        end

        it '投稿一覧画面にリダイレクトすること' do
          subject
          expect(response).to redirect_to posts_url
        end
      end

      context 'パラメータが不正な場合' do
        subject { post posts_url, params: { post: attributes_for(:post, :text_invalid) } }
        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it '投稿が登録されないこと' do
          expect{subject}.to_not change(Post, :count)
        end

        it 'エラーが表示されること' do
          post posts_url, xhr: true, params: { post: attributes_for(:post, :text_invalid) }
          expect(response.body).to include 'Textを入力してください'
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end
      subject { post posts_url, params: { post: attributes_for(:post, :image_present) } }

      it 'ログイン画面にリダイレクトされること' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #edit' do
    context '投稿が存在する場合' do
      subject { get edit_post_url post_instance.id }
      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'レスポンスに適切なimage urlが含まれること' do
          subject
          expect(response.body).to include 'https://example_image_url'
        end

        it 'レスポンスに適切なtextが含まれていること' do
          subject
          expect(response.body).to include 'PostRequestTest :Takashiの投稿'
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

    # TODO:skip
    context '投稿が存在しない場合' do
      before do
        sign_in user
      end

      subject { -> { get edit_post_url 1 } }
      xit { expect(subject).to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'PUT #update' do
    let(:update_params) {
      attributes_for(
        :post,
        user: user,
        text: 'PostUpdateRequest',
        image: 'https://example_update_image_url'
      )
    }
    subject { put post_url post_instance, params: { post: update_params } }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context 'パラメータが妥当な場合' do
        it '302レスポンスを返すこと' do
          subject
          expect(response.status).to eq 302
        end

        it 'image urlが更新されること' do
          expect{subject}
          .to change { Post.find(post_instance.id).image }
          .from('https://example_image_url')
          .to('https://example_update_image_url')
        end

        it 'textが更新されること' do
          expect{subject}
          .to change { Post.find(post_instance.id).text }
          .from('PostRequestTest :Takashiの投稿')
          .to('PostUpdateRequest :Takashiの投稿')
        end

        it 'リダイレクトすること' do
          subject
          expect(response).to redirect_to posts_path
        end
      end

      context 'パラメータが不正な場合' do
        subject { put post_url post_instance, params: { post: attributes_for(:post, :text_invalid) } }
        it '200レスポンスを返すこと' do
          subject
          expect(response.status).to eq 200
        end

        it 'image urlが変更されないこと' do
          subject
          expect{subject}.to_not change(Post.find(post_instance.id), :image)
        end

        it 'textが変更されないこと' do
          subject
          expect{subject}.to_not change(Post.find(post_instance.id), :text)
        end

        it 'エラーが表示されること' do
          put post_url(post_instance), xhr: true, params: { post: attributes_for(:post, :text_invalid) }
          expect(response.body).to include 'Textを入力してください'
        end
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

  describe 'DELETE #delete' do
    subject { delete post_url post_instance }

    context 'ログインしている場合' do
      before do
        sign_in user
        post_instance
      end

      it '302レスポンスを返すこと' do
        subject
        expect(response.status).to eq 302
      end

      it '投稿が削除されること' do
        expect{subject}.to change(Post, :count).by(-1)
      end

      context '投稿に紐づくComment' do
        before do
          post_instance.comments.create({text: "comment_text_1", user_id: user.id})
          post_instance.comments.create({text: "comment_text_2", user_id: user.id})
        end

        it '削除されること' do
          expect{subject}.to change(Comment,:count).by(-2)
        end
      end

      it '投稿一覧画面にリダイレクトすること' do
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
end
