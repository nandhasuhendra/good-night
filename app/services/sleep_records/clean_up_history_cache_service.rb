module SleepRecords
  class CleanUpHistoryCacheService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      Rails.cache.delete_matched("weekly_histories:user_#{@user.id}:week_*")
    end
  end
end
