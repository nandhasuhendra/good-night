module SleepRecords
  class ClockOutService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        record = SleepRecord.find_by(user: @user, clock_out: nil)
        return handler_failure(em_sleep_records_not_found) unless record

        record.update(clock_out: Time.zone.now)
        return handler_success(record: record) if record.save

        handler_failure(record.errors)

        # TODO: Send the result to background job for weekly sleep report
        ::Reports::CalculateWeeklySleepReportJob.perform_async(@user.id, record.id)
      end
    end
  end
end
