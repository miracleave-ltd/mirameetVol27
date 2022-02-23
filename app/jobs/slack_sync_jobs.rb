class SlackSyncJobs < ApplicationJob
  queue_as :slack_sync_jobs

  def perform(model_type, id)
    model = model_type.constantize.find(id)
    model.slack_sync!
  end
end
