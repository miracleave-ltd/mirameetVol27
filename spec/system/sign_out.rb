require 'rails_helper'

RSpec.describe 'SignOut', type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "ユーザーがサインアウトする" do
    sign_in_as create(:user)
    click_link 'ログアウト'

    aggregate_failures do
      expect(current_path).to eq new_user_session_path
      expect(page).to have_selector 'h2', text: 'Log in'
    end
  end
end
