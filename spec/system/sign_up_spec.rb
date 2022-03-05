require 'rails_helper'

RSpec.describe 'SignUp', type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario 'ユーザーはサインアップする' do
    expect {
      visit new_user_registration_path
      fill_in 'user_nickname', with: 'test'
      fill_in 'user_email', with: 'test@sample.com'
      fill_in 'user_password', with: 'p@ssw0rd'
      fill_in 'user_password_confirmation', with: 'p@ssw0rd'
      click_button 'commit'

      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector 'a', text: '投稿する'
      end
    }.to change(User, :count).by(1)
  end

  scenario 'ユーザーは入力項目を未入力の状態でサインアップする' do
    expect {
      visit new_user_registration_path
      fill_in 'user_nickname', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      click_button 'commit'

      aggregate_failures do
        expect(current_path).to eq user_registration_path
        expect(page).to have_selector 'h2', text: 'Sign up'
      end
    }.to_not change(User, :count)
  end
end
