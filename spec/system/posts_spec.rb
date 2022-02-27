require 'rails_helper'

RSpec.feature "Posts", type: :system do
  background do
    driven_by(:rack_test)
  end
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let!(:post) { create(:post, text: 'hello world', user: user_a)}

  describe '投稿/編集/削除/詳細表示/コメントの一連動作' do
    background do
      visit(root_path)
      fill_in 'user_email', with: user_a.email
      fill_in 'user_password', with: user_a.password
      click_button 'commit'
    end
    
    context '基本フロー' do
      
      scenario 'ユーザーは投稿できる' do
        click_link_or_button '投稿する'
        fill_in 'post_text', with: 'sample_text'
        click_button 'commit'
        expect(current_path).to eq posts_path
        expect(page).to have_content 'sample_text'
      end

      scenario 'ユーザーは自分の投稿を閲覧でき、編集できる' do
        visit edit_post_path(post)
        fill_in 'post_text', with: 'This is test.'
        click_button 'commit'
        expect(page).to have_content 'This is test.'
      end

      scenario 'ユーザーは自分の投稿を削除できる' do
        click_link '削除'
        expect(all('.post_content').count).to eq 0
      end

      scenario 'ユーザーは自分の投稿にコメントできる' do
        visit post_path(post)
        fill_in 'text', with: 'good!!'
        click_button 'SEND'
        expect(page).to have_selector('p', text: 'good!', count: 1)
        expect(find('p', text: 'good!').find('a').text).to eq user_a.nickname
      end

      scenario 'ユーザーは他人の投稿を閲覧でき、コメントできる' do
        click_link 'ログアウト'
        fill_in 'user_email', with: user_b.email
        fill_in 'user_password', with: user_b.password
        click_button 'commit'
        visit post_path(post)
        fill_in 'text', with: 'bad!'
        click_button 'SEND'
        expect(page).to have_selector('p', text: 'bad!', count: 1)
        expect(find('p', text: 'bad!').find('a').text).to eq user_b.nickname
      end

      scenario 'ユーザーは自分の投稿一覧を閲覧できる' do
        visit user_path(user_a)
        expect(current_path).to eq user_path(user_a)
      end

      scenario 'ユーザーは他のユーザーの投稿一覧を閲覧できる' do
        click_link 'ログアウト'
        fill_in 'user_email', with: user_b.email
        fill_in 'user_password', with: user_b.password
        click_button 'commit'
        visit user_path(user_a)
        expect(current_path).to eq user_path(user_a)
      end

      scenario '他人の投稿は編集と削除のリンクは表示されない' do
        click_link 'ログアウト'
        fill_in 'user_email', with: user_b.email
        fill_in 'user_password', with: user_b.password
        click_button 'commit'
        expect(page).to have_content 'hello world'
        expect(all(:link, '編集').count).to eq 0
        expect(all(:link, '削除').count).to eq 0
      end

    end

    context '例外フロー' do
      scenario '投稿時に文章欄を未入力にすると投稿できない' do
        click_link('投稿する')
        click_button 'SEND'
        expect(current_path).to eq posts_path
      end

      scenario 'コメントする際にコメント欄を未入力にするとコメントできない' do
        visit post_path(post)
        click_button 'SEND'
        expect(current_path).to eq post_path(post)
        expect(find(class: 'comments').all('p').count).to eq 0
      end

    end
  end

end
