require 'spec_helper'

describe 'cron' do
  it '想定したエントリが登録されている' do
    expect(cron).to have_entry "* * * * * /bin/bash -l -c 'cd /app && RAILS_ENV=development bundle exec rake slack_notification:post --silent >> log/crontab.log 2>&1'"
  end
end