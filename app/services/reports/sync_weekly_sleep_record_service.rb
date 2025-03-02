module Reports
  class SyncWeeklySleepRecordService < ApplicationService
    def initialize(user, week_start)
      @user       = user
      @week_start = week_start
    end

    def call
      ActiveRecord::Base.transaction do
        week_end = @week_start.end_of_week
        sleep_records = SleepRecord.where(user: @user, clock_in: @week_start..week_end)
        return handler_failure(em_sleep_records_not_found) if sleep_records.empty?

        total_sleep = sleep_records.sum(&:sleep_duration)
        average_sleep = total_sleep / sleep_records.size

        weekly_sleep = ReportSleepHistory.find_or_initialize_by(user: @user, week_start: @week_start)
        weekly_sleep.update(total_hours: total_sleep, average_hours: average_sleep)
        return handler_success(weekly_sleep: weekly_sleep) if weekly_sleep.save

        handler_failure(weekly_sleep.errors)
      end
    end
  end
end
