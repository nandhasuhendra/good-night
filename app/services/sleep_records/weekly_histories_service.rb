module SleepRecords
  class WeeklyHistoriesService < ApplicationService
    include Pagy::Backend

    BATCH_SIZE = 500

    def initialize(user, week_start, options = {})
      @user       = user
      @week_start = week_start || Date.today.beginning_of_week
      @options    = options
    end

    def call
      sleep_histories = fetch_sleep_histories
      Rails.cache.write(cache_key, sleep_histories, expires_in: 1.hour)
      pagy, sleep_histories = pagy_array(sleep_histories, page: page, items: per_page)

      { pagy: pagy, sleep_histories: sleep_histories }
    end

    private

    def page
      (@options[:page] || 1).to_i
    end

    def per_page
      (@options[:per_page] || Pagy::DEFAULT[:limit]).to_i
    end

    def cache_key
      week_number = @week_start.strftime("%Y_%W")
      "weekly_histories:user_#{@user.id}:week_#{week_number}:page_#{page}:per_page_#{per_page}"
    end

    def fetch_sleep_histories
      return Rails.cache.read(cache_key) if Rails.cache.exist?(cache_key)

      following_user_ids = @user.following.pluck(:id)
      return [] if following_user_ids.blank?

      sleep_histories = fetch_data_from_database(following_user_ids)
      return [] if sleep_histories.blank?

      sleep_histories
    end

    def fetch_data_from_database(following_user_ids)
      sleep_records = []

      # Use batch processing to avoid SQL issue `WHERE attr_ids IN (...) Too many` fetching all sleep records at once
      following_user_ids.each_slice(BATCH_SIZE) do |user_ids|
        sleep_records += fetch_data_from_database_query(user_ids)
      end

      sleep_records.sort_by! { |record| -record.sleep_duration.to_i }
    end

    def fetch_data_from_database_query(user_ids)
      SleepRecord
        .joins(:user)
        .select("users.name AS user_name", "sleep_records.*")
        .where(user_id: user_ids)
        .where("clock_in::DATE >= ? AND clock_in::DATE < ?", @week_start, @week_start + 7.days)
        .order(sleep_duration: :desc)
    end
  end
end
