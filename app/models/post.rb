class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  after_save :start_slack_sync

  validates :text, presence: true, length: { maximum: 255 }
  validates :image, format: /\A#{URI::regexp(%w(http https))}\z/, allow_blank: true

  def start_slack_sync
    Resque.enqueue(SlackSyncJobs, self.class.name, self.id)
  end

  def slack_sync!
    Slack::SendPostService.new(user.nickname).send_post(text)
  end
end
