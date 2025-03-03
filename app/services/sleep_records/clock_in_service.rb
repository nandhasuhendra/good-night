module SleepRecords
  class ClockInService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        record = SleepRecord.new(user: @user, clock_in: Time.zone.now)
        return handler_failure(record.errors.messages) unless record.save

        handler_success(record: record)
      end
    end
  end
end
