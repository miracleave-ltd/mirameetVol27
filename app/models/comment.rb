class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :text, presence: true, length: { maximum: 100 }
end
