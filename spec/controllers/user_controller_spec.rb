require 'rails_helper'
# showアクションの機能テスト
# ログインしているユーザ
# ログインしているユーザのニックネーム
# ログインしているユーザのコメント
# bundle exec rspec spec/controllers/user_controller_spec.rb 
# マイページを作成しよう
# コントローラーでテストでは、
# ページの表示が正常になされているかどうか
# 要素の受け渡しが正常になされているかどうか
# 権限が有効になっていて、且つそれが正常になされているかどうかといった点を点検していきます。
# 現在、ログインをしているユーザを取得する方法がわからない。
# user = User.find(current_user.id) これだと、メソッドエラーとなる。だが、user_controllerでは有効
RSpec.describe 'UsersControllers', type: :request do
  describe '#showアクションテスト' do
    context 'ユーザが存在する場合' do
      let(:user) { create(:user, nickname: 'Toshio') }
      let(:post_instance) { create(:post, user: user, text: 'PostTest', image: 'https://example_image_url') }

      context 'ログインしている場合' do
        before do
          sign_in user
          post_instance
        end

        it 'リクエストが成功すること' do
          get user_path user.id
          expect(response.status).to eq 200
        end

        it 'ユーザー名が表示していること' do
          get user_path user.id
          expect(user.nickname).to eq 'Toshio'          
        end

        it '投稿が表示されていること' do
          expect(post_instance.text).to include 'PostTest'        
        end        

      end
    end
    # it "responds successfully" do
    #   # binding pry
    #   # user = User.find(1)
    #   # user = User.find(params[:id])
    #   # user = User.find(2)
    #   user = User.find(current_user.id)
    #   # user = current_user.nickname
    #   expect(user.nickname).to eq "Toshi"
    #   # get :show
    #   # expect(response).to be_success
    # end
  end
end