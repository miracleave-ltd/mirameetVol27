class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  before_save :add_date_to_text
  after_save :start_slack_sync

  validates :text, presence: true, length: { maximum: 255 }
  validates :image, format: /\A#{URI::regexp(%w(http https))}\z/, allow_blank: true

  def add_date_to_text
    self.text += " :#{self.user&.nickname}の投稿" if self.text.present?
  end

  def start_slack_sync
    Resque.enqueue(SlackSyncJobs, self.class.name, self.id)
  end

  def slack_sync!
    Slack::SendPostService.new(user.nickname).send_post(text)
  end
end
