require 'rails_helper'

describe Post do
  let(:post) { create(:post, user: create(:user)) }
  subject { SlackSyncJobs.perform(post.class.name, post.id) }

  context '' do
    before do
      allow(post.class.name.constantize).to receive(:find).with(post.id).and_return(post)
      allow(post).to receive(:slack_sync!)
    end

    it '適切にメソッドを呼び出しているか' do
      subject
      expect(post.class.name.constantize).to have_received(:find).with(post.id)
      expect(post).to have_received(:slack_sync!)
    end
  end
end
