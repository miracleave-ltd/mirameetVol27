class SlackSyncJobs
  @queue = :slack_sync_jobs

  class << self
    def perform(model_type, id)
      model = model_type.constantize.find(id)
      model.slack_sync!
    end
  end
end
