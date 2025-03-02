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

  validates :clock_in, presence: true, uniqueness: { scope: :user_id }

  before_commit :set_duration

  private

  def set_duration
    return unless clock_out.present?

    self.duration = (clock_out - clock_in).to_i
  end
end
