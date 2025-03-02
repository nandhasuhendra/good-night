module Reports
  class CalculateWeeklySleepReportJob
    include Sidekiq::Worker

    sidekiq_options queue: 'weekly_sleep_report', retry: 3

    def perform(user_id, sleep_record_id)
      user = User.find(user_id)
      sleep_record = SleepRecord.find(sleep_record_id)
      week_start = sleep_record.clock_in.beginning_of_week

      ::Reports::SyncWeeklySleepRecordService.call(user, week_start)
    end
  end
end
