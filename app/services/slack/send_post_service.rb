module  Slack
  class SendPostService

    def initialize(user_name)
      webhook_url = ENV['SLACK_WEBHOOK_URL']
      channel = "##{ENV['CHANNEL_NAME']}"
      @client ||= Slack::Notifier.new(webhook_url, channel: channel, username: user_name)
    end

    def send_post(message)
      @client.ping(message)
    end
  end
end
