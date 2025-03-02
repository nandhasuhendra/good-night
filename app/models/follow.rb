# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  followed_id  :integer          not null
#  following_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  idx_follows_following_id_followed_id  (following_id,followed_id) UNIQUE
#

class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: "following_id"
  belongs_to :followed, class_name: "User", foreign_key: "followed_id"

  validates :following_id, :followed_id, presence: true
  validates :following_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_yourself

  private

  def cannot_follow_yourself
    errors.add(:following_id, I18n.t("errors.messages.follow.cannot_follow_yourself")) if following_id == followed_id
  end
end
