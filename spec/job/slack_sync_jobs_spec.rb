require 'rails_helper'

describe SlackSyncJobs do
  include ActiveJob::TestHelper
  let(:post) { create(:post, user: create(:user)) }
  subject { SlackSyncJobs.perform_now(post.class.name, post.id) }

  context '#perform' do
    before do
      allow(post.class.name.constantize).to receive(:find).with(post.id).and_return(post)
      allow(post).to receive(:slack_sync!)
    end

    it 'sholud call the appropriate method' do
      subject
      expect(post.class.name.constantize).to have_received(:find).with(post.id)
      expect(post).to have_received(:slack_sync!)
    end
  end

  context 'post to slack' do
    ActiveJob::Base.queue_adapter = :test
    it 'should job has been queued', :vcr do
      expect {
        SlackSyncJobs.perform_later(post.class.name, post.id)
      }.to have_enqueued_job(SlackSyncJobs).with('Post', post.id)
    end
  end
end
