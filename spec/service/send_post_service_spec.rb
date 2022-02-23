require 'rails_helper'

describe Slack::SendPostService do
  describe 'slack alignment' do
    context "#send_post" do
      it 'post to slack', :vcr do
        response = Slack::SendPostService.new('user_nickname').send_post('test_message')
        expect(response.first.message).to eq("OK")
      end
    end
  end
end
