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
        return handler_failure(record.errors.messages) unless record.save

        handler_success(record: record)
      end
    end
  end
end
