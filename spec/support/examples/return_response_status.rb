RSpec.shared_examples 'return_response_status' do |status_no|
  it "#{status_no}レスポンスを返すこと" do
    subject
    expect(response.status).to eq status_no
  end
end