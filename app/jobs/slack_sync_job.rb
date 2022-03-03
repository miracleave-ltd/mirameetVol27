class SlackSyncJob < ApplicationJob
  queue_as :slack_sync_jobs

  def perform(post)
    post.slack_sync!
  end
end
