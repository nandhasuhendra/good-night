class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true

  has_many :followers, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  has_many :followings, foreign_key: :followed_id, class_name: "Follow", dependent: :destroy
end
