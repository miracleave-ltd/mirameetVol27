require 'rails_helper'

RSpec.feature "Users", type: :system do
  background do
    driven_by(:rack_test)
  end

  describe 'サインアップ/ログイン/ログアウトの一連動作' do
    
    subject {
      visit(new_user_registration_path)
      fill_in 'user_nickname', with: 'test'
      fill_in 'user_email', with: 'test@sample.com'
      fill_in 'user_password', with: 'p@ssw0rd'
      fill_in 'user_password_confirmation', with: 'p@ssw0rd'
      click_button 'commit'
    }

    context '基本フロー' do

      scenario 'ユーザー作成後、ログインしてTOPページへリダイレクトする' do
        subject
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウト'
      end
      
      scenario 'ログアウト後、ログイン画面にリダイレクトする' do
        subject
        click_link 'ログアウト'
        expect(current_path).to eq new_user_session_path
      end

      scenario 'ログアウト後、再ログインする' do
        subject
        click_link 'ログアウト'
        fill_in 'user_email', with: 'test@sample.com'
        fill_in 'user_password', with: 'p@ssw0rd'
        click_button 'commit'
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウト'
      end

    end

    context  '例外フロー' do

      scenario 'ユーザー作成時に入力必須項目を空にすると作成できない' do
        visit(new_user_registration_path)
        fill_in 'user_nickname', with: ''
        fill_in 'user_email', with: 'test@sample.com'
        fill_in 'user_password', with: 'p@ssw0rd'
        fill_in 'user_password_confirmation', with: 'p@ssw0rd'
        click_button 'commit'
        expect(page).to have_content 'Nicknameを入力してください'
      end

      scenario 'ユーザーログイン時に入力必須項目を空にするとログインできない' do
        subject
        click_link 'ログアウト'
        fill_in 'user_email', with: 'test@sample.com'
        fill_in 'user_password', with: ''
        click_button 'commit'
        expect(current_path).to eq new_user_session_path
      end

    end
  end
end