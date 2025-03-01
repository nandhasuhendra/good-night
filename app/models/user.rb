class User < ApplicationRecord
  has_secure_password

  has_many :following_relationships, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :follower_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :following_relationships, source: :followed
  has_many :followers, through: :follower_relationships, source: :follower

  validates :name, presence: true, uniqueness: true
end
