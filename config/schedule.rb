require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/crontab.log'
set :environment, ENV['RAILS_ENV'] || :development
env :PATH, ENV['PATH']

every 1.minutes do
  rake 'slack_notification:post'
end
