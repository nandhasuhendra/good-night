module SleepRecords
  class ClockOutService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        record = SleepRecordRepository.clock_out_user!(@user)
        handler_success(record: record)
      rescue ActiveRecord::RecordInvalid => e
        handler_failure(e.record.errors)
      end
    end
  end
end
