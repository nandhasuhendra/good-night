module SleepRecords
  class ClockInService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        record = SleepRecord.new(user: @user, clock_in: Time.zone.now)
        return handler_success(record: record) if record.save

        handler_failure(record.errors.messages)
      end
    end
  end
end
