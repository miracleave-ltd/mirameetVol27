class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments

  validates :nickname, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :password_confirmation, presence: true
end
