RSpec.shared_examples 'ログインしていない場合' do
  before do
    sign_out user
  end

  it '302レスポンスを返すこと' do
    subject
    expect(response.status).to eq 302
  end

  it 'ログイン画面にリダイレクトされること' do
    subject
    expect(response).to redirect_to new_user_session_url
  end
end