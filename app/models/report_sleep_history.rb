# == Schema Information
#
# Table name: report_sleep_histories
#
#  id            :integer          not null, primary key
#  week_start    :date             not null
#  total_hours   :integer          not null
#  average_hours :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_report_sleep_histories_on_user_id                 (user_id)
#  index_report_sleep_histories_on_user_id_and_week_start  (user_id,week_start) UNIQUE
#

class ReportSleepHistory < ApplicationRecord
  belongs_to :user

  validates :user, :week_start, :total_hours, :average_hours, presence: true
  validates :week_start, uniqueness: { scope: :user_id }
end
