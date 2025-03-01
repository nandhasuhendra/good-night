class Follow < ApplicationRecord
  belongs_to :following, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :following_id, :followed_id, presence: true
  validates :following_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_yourself

  private

  def cannot_follow_yourself
    errors.add(:following_id, I18n.t("errors.messages.follow.cannot_follow_yourself")) if following_id == followed_id
  end
end
