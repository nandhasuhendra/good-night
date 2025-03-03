# == Schema Information
#
# Table name: sleep_records
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  clock_in       :datetime         not null
#  clock_out      :datetime
#  sleep_duration :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  idx_sleep_records_user_clock_in  (user_id,clock_in) UNIQUE
#  index_sleep_records_on_user_id   (user_id)
#

class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :user, :clock_in, presence: true
  validates :user_id, uniqueness: { scope: :clock_in }
  validate :active_clock_in_exist, on: :create

  before_save :set_duration
  after_commit :publish_event

  private

  def set_duration
    return unless clock_out.present?

    self.sleep_duration = (clock_out - clock_in).to_i
  end

  def active_clock_in_exist
    return unless user.present?

    if SleepRecord.exists?(user_id: user_id, clock_out: nil)
      errors.add(:clock_in, I18n.t("errors.messages.sleep_record.active_sleep_record_exist"))
    end
  end

  def publish_event
    ActiveSupport::Notifications.instrument("follow.changed", record: self, user: self.user)
  end
end
