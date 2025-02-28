class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true

  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :followed
end
