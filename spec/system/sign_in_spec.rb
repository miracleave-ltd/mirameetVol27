require 'rails_helper'

RSpec.describe 'SignIn', type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) { create(:user) }

  scenario "ユーザーがサインインする" do
    visit user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'commit'

    aggregate_failures do
      expect(current_path).to eq root_path
      expect(page).to have_selector 'a', text: '投稿する'
    end
  end

  scenario 'ユーザーは入力項目を未入力の状態でサインインする' do
    visit user_session_path
    fill_in 'user_email', with: ''
    fill_in 'user_password', with: ''
    click_button 'commit'

    aggregate_failures do
      expect(current_path).to eq new_user_session_path
      expect(page).to have_selector 'h2', text: 'Log in'
    end
  end
end
