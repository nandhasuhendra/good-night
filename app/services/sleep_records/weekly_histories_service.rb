module SleepRecords
  class WeeklyHistoriesService < ApplicationService
    def initialize(user_id, user_ids, week_start)
      @user_id    = user_id
      @user_ids   = user_ids
      @week_start = week_start || Date.today.beginning_of_week
    end

    def call
      fetch_sleep_histories
    end

    private

    def fetch_sleep_histories
      SleepRecord.joins(:user)
                 .select('users.name AS user_name', 'sleep_records.*')
                 .where(user_id: @user_ids)
                 .where('clock_in::DATE >= ? AND clock_in::DATE < ?', @week_start, @week_start + 7.days)
                 .order(sleep_duration: :desc)
    end
  end
end
