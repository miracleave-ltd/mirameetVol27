namespace 'slack_notification' do
  task :post => :environment do
    Slack::SendPostService.new('batch').send_post("batch_test:#{Time.zone.now}")
  end
end
