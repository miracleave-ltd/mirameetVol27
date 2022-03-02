require 'rails_helper'

RSpec.feature "Posts", type: :system do
  background do
    driven_by(:rack_test)
  end
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let!(:post) { create(:post, text: 'hello world', user: user_a)}

  describe '投稿/編集/削除/詳細表示/コメントの一連動作' do
    # before do
    #   sign_in_as user_a
    # end

    context '基本フロー' do
      scenario 'ユーザーは新しい投稿を作成する' do
        expect {
          # Capybaraのデバッグメソッド
          visit posts_path
          save_page

          # こちらはブラウザを自動で開くメソッド。コンテナ環境だと動作しない
          # save_and_open_page


          click_link_or_button '投稿する'
          fill_in 'post_text', with: 'sample_text'
          click_button 'commit'

          expect(current_path).to eq posts_path
          expect(page).to have_content 'sample_text'
        }.to change(user_a.posts, :count).by(1)
      end
    end
  end
end
