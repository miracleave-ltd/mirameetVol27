class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  after_save :start_slack_sync

  def start_slack_sync
    Resque.enqueue(SlackSyncJobs, self.class.name, self.id)
  end

  def slack_sync!
    client = Slack::Web::Client.new
    client.chat_postMessage(
      # channel名: "#channel_name"。"channel_name"は不可。
      channel: "##{ENV['CHANNEL_NAME']}",
      text: text
    )
  end
end
