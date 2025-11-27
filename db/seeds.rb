# Database Dataset
# This creates a realistic dataset with 1K users and 5 years of active usage
if ENV["DUMMY_DATA"] == 'true'
  start_time = Time.current
  puts "\n" + "="*80
  puts "DATABASE DATASET GENERATOR"
  puts "="*80
  puts "[#{start_time.strftime('%H:%M:%S')}] Starting dataset creation..."
  puts "[#{Time.current.strftime('%H:%M:%S')}] Rails Environment: #{Rails.env}"
  puts "[#{Time.current.strftime('%H:%M:%S')}] Database Adapter: #{ActiveRecord::Base.connection.adapter_name}"
  puts "[#{Time.current.strftime('%H:%M:%S')}] Creating 1,000 users for dataset..."

  # Create 1,000 users with realistic registration dates spanning 5 years
  users = []
  registration_start = 5.years.ago
  registration_end = 1.year.ago # Most users joined before the last year
  user_start_time = Time.current

  1_000.times do |i|
    # Generate realistic registration date (more users in recent years)
    registration_date = if i < 200
      # Early adopters (5-4 years ago)
      rand(registration_start..4.years.ago)
    elsif i < 600
      # Growth phase (4-2 years ago)
      rand(4.years.ago..2.years.ago)
    else
      # Recent users (2 years ago to 1 year ago)
      rand(2.years.ago..registration_end)
    end

    user = User.create!(
      name: "User#{i.to_s.rjust(4, '0')}", # User0001, User0002, etc.
      password: "password123",
      password_confirmation: "password123",
      created_at: registration_date,
      updated_at: registration_date
    )
    users << user

    if (i + 1) % 100 == 0
      elapsed = Time.current - user_start_time
      progress_pct = ((i + 1) / 10.0).round(1)
      avg_time_per_user = elapsed / (i + 1)
      remaining_users = 1000 - (i + 1)
      eta_seconds = remaining_users * avg_time_per_user
      eta = Time.current + eta_seconds
      puts "[#{Time.current.strftime('%H:%M:%S')}] Created #{i + 1}/1000 users (#{progress_pct}%) - ETA: #{eta.strftime('%H:%M:%S')}"
    end
  end

  user_creation_time = Time.current - user_start_time
  puts "[#{Time.current.strftime('%H:%M:%S')}] Users created in #{user_creation_time.round(2)}s"
  puts "[#{Time.current.strftime('%H:%M:%S')}] Creating realistic follow relationships..."

  # Create realistic follow patterns
  follow_count = 0
  follow_start_time = Time.current
  users.each_with_index do |user, index|
    # Determine how many people this user follows (realistic distribution)
    follows_count = case rand(100)
    when 0..20   # 20% follow very few (0-5 people)
      rand(0..5)
    when 21..60  # 40% follow moderate amount (6-25 people)
      rand(6..25)
    when 61..85  # 25% follow many (26-75 people)
      rand(26..75)
    when 86..95  # 10% follow lots (76-150 people)
      rand(76..150)
    else         # 5% are super active (151-300 people)
      rand(151..300)
    end

    # Some users might follow almost everyone (for partition testing)
    if index < 5 # First 5 users are super connectors
      follows_count = rand(800..999)
    end

    # Get potential users to follow (excluding self)
    potential_follows = users.reject { |u| u.id == user.id }

    # Create follows with realistic patterns
    follows_count.times do
      # Bias towards following users who joined around the same time or earlier
      if rand < 0.7 # 70% chance to follow someone from similar timeframe
        similar_timeframe_users = potential_follows.select do |u|
          (u.created_at - user.created_at).abs <= 1.year
        end
        target_user = similar_timeframe_users.sample if similar_timeframe_users.any?
      end

      # Fallback to any user if no similar timeframe users
      target_user ||= potential_follows.sample

      next unless target_user

      # Create follow relationship if it doesn't exist
      unless Follow.exists?(following_id: user.id, followed_id: target_user.id)
        Follow.create!(
          following_id: user.id,
          followed_id: target_user.id,
          created_at: rand(user.created_at..Time.current),
          updated_at: rand(user.created_at..Time.current)
        )
        follow_count += 1
        potential_follows.delete(target_user) # Avoid duplicate follows
      end
    end

    if (index + 1) % 50 == 0
      elapsed = Time.current - follow_start_time
      progress_pct = ((index + 1) / 10.0).round(1)
      avg_time_per_user = elapsed / (index + 1)
      remaining_users = 1000 - (index + 1)
      eta_seconds = remaining_users * avg_time_per_user
      eta = Time.current + eta_seconds
      puts "[#{Time.current.strftime('%H:%M:%S')}] Follow relationships: #{index + 1}/1000 users (#{progress_pct}%) - #{follow_count} total follows - ETA: #{eta.strftime('%H:%M:%S')}"
    end
  end

  follow_creation_time = Time.current - follow_start_time
  puts "[#{Time.current.strftime('%H:%M:%S')}] Follow relationships created in #{follow_creation_time.round(2)}s"
  puts "[#{Time.current.strftime('%H:%M:%S')}] Creating 5 years of sleep records for all users..."
  puts "[#{Time.current.strftime('%H:%M:%S')}] This may take several minutes due to the volume of data..."

  # Create realistic sleep records for each user over 5 years
  sleep_start_time = Time.current
  total_sleep_records_created = 0
  users.each_with_index do |user, user_index|
    # Each user has been active since their registration
    start_date = user.created_at.to_date
    end_date = Date.current

    # Generate sleep records for each day since registration
    current_date = start_date
    sleep_records_count = 0

    while current_date <= end_date
      # 85% chance user records sleep on any given day (realistic usage)
      if rand < 0.85
        # Generate realistic sleep times
        base_bedtime_hour = rand(21..24) # 9 PM to midnight
        base_bedtime_minute = rand(0..59)

        # Add some variation (±2 hours)
        bedtime_variation = rand(-120..120) # minutes

        clock_in_time = current_date.beginning_of_day +
                       base_bedtime_hour.hours +
                       base_bedtime_minute.minutes +
                       bedtime_variation.minutes

        # Sleep duration: 4-12 hours, most commonly 6-8 hours
        sleep_duration_hours = case rand(100)
        when 0..5    # 5% short sleep (4-5 hours)
          rand(4.0..5.0)
        when 6..15   # 10% long sleep (9-12 hours)
          rand(9.0..12.0)
        else         # 85% normal sleep (5.5-9 hours)
          rand(5.5..9.0)
        end

        clock_out_time = clock_in_time + sleep_duration_hours.hours

        # Sometimes users forget to clock out (5% of records)
        if rand < 0.05
          clock_out_time = nil
        end

        begin
          SleepRecord.create!(
            user: user,
            clock_in: clock_in_time,
            clock_out: clock_out_time,
            created_at: clock_in_time + rand(0..3600).seconds, # Created within an hour of clock_in
            updated_at: clock_out_time ? clock_out_time + rand(0..1800).seconds : clock_in_time + rand(0..3600).seconds
          )
          sleep_records_count += 1
        rescue ActiveRecord::RecordInvalid
          # Skip if validation fails (e.g., duplicate clock_in times)
        end
      end

      current_date += 1.day
    end

    total_sleep_records_created += sleep_records_count

    if (user_index + 1) % 50 == 0
      elapsed = Time.current - sleep_start_time
      progress_pct = ((user_index + 1) / 10.0).round(1)
      avg_time_per_user = elapsed / (user_index + 1)
      remaining_users = 1000 - (user_index + 1)
      eta_seconds = remaining_users * avg_time_per_user
      eta = Time.current + eta_seconds
      avg_records_per_user = total_sleep_records_created / (user_index + 1)
      puts "[#{Time.current.strftime('%H:%M:%S')}] Sleep records: #{user_index + 1}/1000 users (#{progress_pct}%) - #{total_sleep_records_created} total records (avg: #{avg_records_per_user.round(1)}/user) - ETA: #{eta.strftime('%H:%M:%S')}"
    elsif (user_index + 1) % 10 == 0
      puts "[#{Time.current.strftime('%H:%M:%S')}] Processing user #{user_index + 1}/1000 - #{sleep_records_count} records created for User#{user_index.to_s.rjust(4, '0')}"
    end
  end

  sleep_creation_time = Time.current - sleep_start_time
  total_execution_time = Time.current - start_time

  # Print final statistics
  total_users = User.count
  total_follows = Follow.count
  total_sleep_records = SleepRecord.count

  puts "\n" + "="*80
  puts "DATASET CREATED SUCCESSFULLY!"
  puts "="*80
  puts "DATASET STATISTICS:"
  puts "   Total Users: #{total_users.to_s.rjust(20)}"
  puts "   Total Follows: #{total_follows.to_s.rjust(18)}"
  puts "   Total Sleep Records: #{total_sleep_records.to_s.rjust(11)}"
  puts "   Average Follows per User: #{(total_follows.to_f / total_users).round(2).to_s.rjust(8)}"
  puts "   Average Sleep Records per User: #{(total_sleep_records.to_f / total_users).round(2).to_s.rjust(3)}"
  puts "   Date Range: #{SleepRecord.minimum(:clock_in)&.strftime('%Y-%m-%d')} to #{SleepRecord.maximum(:clock_in)&.strftime('%Y-%m-%d')}"
  puts "\nPERFORMANCE METRICS:"
  puts "   Total Execution Time: #{total_execution_time.round(2)}s (#{(total_execution_time / 60).round(2)} minutes)"
  puts "   User Creation Time: #{user_creation_time.round(2)}s"
  puts "   Follow Creation Time: #{follow_creation_time.round(2)}s"
  puts "   Sleep Records Creation Time: #{sleep_creation_time.round(2)}s"
  puts "   Records per Second: #{(total_sleep_records / sleep_creation_time).round(2)}"
  puts "\nDATABASE SIZE ESTIMATION:"
  puts "   Estimated Users table size: ~#{(total_users * 150).to_s.rjust(8)} bytes"
  puts "   Estimated Follows table size: ~#{(total_follows * 50).to_s.rjust(7)} bytes"
  puts "   Estimated Sleep Records table size: ~#{(total_sleep_records * 100).to_s.rjust(2)} bytes"
  total_estimated_size = (total_users * 150) + (total_follows * 50) + (total_sleep_records * 100)
  puts "   Total estimated database size: ~#{(total_estimated_size / 1024.0 / 1024.0).round(2)} MB"
  puts "="*80
end
