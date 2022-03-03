require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user, nickname: 'Takashi') }
  let(:post_instance) { create(:post, user: user, text: 'PostRequestTest', image: 'https://example_image_url') }

  describe '投稿一覧' do
    subject { get posts_url }

    context 'ログインしている場合' do
      before do
        sign_in user
        post_instance
      end

      it_behaves_like 'return_response_status', 200

      it 'レスポンスに適切な投稿内容を含むこと' do
        subject
        aggregate_failures do
          expect(response.body).to include 'PostRequestTest :Takashiの投稿'
          expect(response.body).to include '<span>投稿者</span>Takashi'
        end
      end
    end

    it_behaves_like 'ログインしていない場合'
  end

  describe '投稿詳細' do
    context '投稿が存在する場合' do
      subject { get post_url post_instance.id }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it_behaves_like 'return_response_status', 200

        it 'レスポンスに適切な投稿とコメント表示欄を含むこと' do
          subject
          aggregate_failures do
            expect(response.body).to include 'PostRequestTest :Takashiの投稿'
            expect(response.body).to include '<span>投稿者</span>Takashi'
            expect(response.body).to include '<h4><コメント一覧></h4>'
          end
        end
      end

      it_behaves_like 'ログインしていない場合'
    end

    context '投稿が存在しない場合' do
      before do
        sign_in user
      end

      it '例外が発生すること' do
        expect do
          get post_url 1
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '投稿新規登録' do
    subject { get new_post_url }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it_behaves_like 'return_response_status', 200
    end

    it_behaves_like 'ログインしていない場合'
  end

  describe '投稿新規作成' do
    subject {
      post posts_url,
      params: { post: attributes_for(:post) }
    }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context 'パラメータが妥当な場合' do
        it_behaves_like 'return_response_status', 302

        it '投稿が登録されること' do
          expect{subject}.to change(Post, :count).by(1)
        end

        it '投稿一覧画面にリダイレクトすること' do
          subject
          expect(response).to redirect_to posts_url
        end
      end

      context 'パラメータが不正な場合' do
        subject {
          post posts_url,
          params: { post: attributes_for(:post, :text_invalid) }
        }

        it_behaves_like 'return_response_status', 200

        it '投稿が登録されないこと' do
          expect{subject}.to_not change(Post, :count)
        end

        it 'エラーが表示されること' do
          post posts_url, xhr: true, params: { post: attributes_for(:post, :text_invalid) }
          expect(response.body).to include 'Textを入力してください'
        end
      end
    end

    it_behaves_like 'ログインしていない場合'
  end

  describe '投稿編集' do
    context '投稿が存在する場合' do
      subject { get edit_post_url post_instance.id }

      context 'ログインしている場合' do
        before do
          sign_in user
        end

        it_behaves_like 'return_response_status', 200

        it 'レスポンスに適切なimage urlが含まれること' do
          subject
          expect(response.body).to include 'https://example_image_url'
        end

        it 'レスポンスに適切なtextが含まれていること' do
          subject
          expect(response.body).to include 'PostRequestTest :Takashiの投稿'
        end
      end

      it_behaves_like 'ログインしていない場合'
    end

    context '投稿が存在しない場合' do
      before do
        sign_in user
      end

      it '例外が発生すること' do
        expect do
          get edit_post_url 1
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '投稿更新' do
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
        it_behaves_like 'return_response_status', 302

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
        subject {
          put post_url post_instance,
          params: { post: attributes_for(:post, :text_invalid) }
        }

        it_behaves_like 'return_response_status', 200

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

    it_behaves_like 'ログインしていない場合'
  end

  describe '投稿削除' do
    subject { delete post_url post_instance }

    context 'ログインしている場合' do
      before do
        sign_in user
        post_instance
      end

      it_behaves_like 'return_response_status', 302

      it '投稿が削除されること' do
        expect{subject}.to change(Post, :count).by(-1)
      end

      describe '投稿に紐づくComment' do
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

    it_behaves_like 'ログインしていない場合'
  end
end
