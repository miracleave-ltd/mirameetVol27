require 'rails_helper'

RSpec.feature 'Posts', type: :system do
  background do
    driven_by(:rack_test)
  end
  let(:user_a) { create(:user, nickname: 'Takashi') }
  let(:user_b) { create(:user, nickname: 'Satoshi') }
  let!(:post) { create(:post, text: 'hello world', user: user_a)}
  before do
    sign_in_as user_a
  end

  describe '投稿の作成' do
    scenario 'ユーザーは新しい投稿を作成する' do
      ActiveJob::Base.queue_adapter = :test

      expect {
        click_link_or_button '投稿する'
        fill_in 'post_text', with: 'sample_text'
        click_button 'commit'

        post = Post.find_by_text_and_user_id('sample_text :Takashiの投稿', user_a.id)

        aggregate_failures do
          expect(current_path).to eq posts_path
          expect(page).to have_content 'sample_text'
          expect {
            SlackSyncJob.perform_later(post)
          }.to have_enqueued_job.with(post)
        end
      }.to change(user_a.posts, :count).by(1)
    end

    scenario 'ユーザーは文章欄を未入力で投稿する' do
      click_link('投稿する')
      click_button 'SEND'

      expect(current_path).to eq posts_path
    end
  end

  describe '投稿の編集' do
    scenario 'ユーザーは自分の投稿を閲覧し、編集する' do
      expect {
        visit edit_post_path(post)
        fill_in 'post_text', with: 'This is Update text.'
        click_button 'commit'

        aggregate_failures do
          expect(current_path).to eq posts_path
          expect(page).to have_content 'This is Update text.'
        end
      }.to change{ Post.find(post.id).text }
      .from('hello world :Takashiの投稿')
      .to('This is Update text. :Takashiの投稿')
    end
  end

  describe '投稿の削除' do
    scenario 'ユーザーは自分の投稿を削除する' do
      expect {
        click_link '削除'

        expect(all('.post_content').count).to eq 0
      }.to change(user_a.posts, :count).by(-1)
    end
  end

  describe '投稿へのコメント' do
    scenario 'ユーザーは自分の投稿にコメントする' do
      expect {
        visit post_path(post)
        fill_in 'comment_text', with: 'good!!'
        click_button 'SEND'

        aggregate_failures do
          expect(page).to have_selector('p', text: 'good!', count: 1)
          expect(find('p', text: 'good!').find('a').text).to eq user_a.nickname
        end
      }.to change(user_a.comments, :count).by(1)
    end

    scenario 'ユーザーは他人の投稿を閲覧し、コメントする' do
      sign_out user_a
      sign_in_as user_b

      expect {
        visit post_path(post)
        fill_in 'comment_text', with: 'bad!'
        click_button 'SEND'

        aggregate_failures do
          expect(page).to have_selector('p', text: 'bad!', count: 1)
          expect(find('p', text: 'bad!').find('a').text).to eq user_b.nickname
        end
      }.to change(user_b.comments, :count).by(1)
    end

    scenario 'ユーザーはコメント欄を未入力でコメントする' do
      visit post_path(post)
      click_button 'SEND'

      expect(current_path).to eq post_path(post)
      expect(find(class: 'comments').all('p').count).to eq 0
    end
  end

  describe 'ユーザーの投稿一覧' do
    scenario 'ユーザーは自分の投稿一覧を閲覧する' do
      visit user_path(user_a)

      expect(current_path).to eq user_path(user_a)
    end

    scenario 'ユーザーは他のユーザーの投稿一覧を閲覧する' do
      sign_out user_a
      sign_in_as user_b

      visit user_path(user_a)

      expect(current_path).to eq user_path(user_a)
    end
  end

  scenario 'ユーザーは他人の投稿の編集と削除をする' do
    sign_out user_a
    sign_in_as user_b

    aggregate_failures do
      expect(page).to have_content 'hello world'
      expect(all(:link, '編集').count).to eq 0
      expect(all(:link, '削除').count).to eq 0
    end
  end
end
