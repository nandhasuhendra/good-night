class SleepRecordRepository
  def self.clock_out_user!(user)
    record = SleepRecord.find_by!(user: @user, clock_out: nil)
    record.update!(clock_out: Time.zone.now)
  end

  def self.weekly_histories_by_user_ids(user_ids, week_start)
    SleepRecord
      .joins(:user)
      .select("users.name AS user_name", "sleep_records.*")
      .where(user_id: user_ids)
      .where("clock_in::DATE >= ? AND clock_in::DATE < ?", week_start, week_start + 7.days)
      .order(sleep_duration: :desc)
  end
end
