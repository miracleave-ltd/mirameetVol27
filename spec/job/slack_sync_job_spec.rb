require 'rails_helper'

RSpec.describe SlackSyncJob, type: :job do
  it 'Postのslack_sync!を呼ぶこと' do
    post = instance_double('Post')
    expect(post).to receive(:slack_sync!)
    SlackSyncJob.perform_now(post)
  end
end
