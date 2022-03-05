RSpec.shared_examples 'ログインしていない場合' do
  before do
    sign_out user
  end

  include_examples 'return_response_status', 302

  it 'ログイン画面にリダイレクトされること' do
    subject
    expect(response).to redirect_to new_user_session_url
  end
end