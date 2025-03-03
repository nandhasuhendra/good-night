ActiveSupport::Notifications.subscribe("follow.changed") do |_name, _start, _finish, _id, payload|
  ::Friends::CleanUpCacheService.call(payload[:user])
  ::SleepRecords::CleanUpHistoryCacheService.call(payload[:user])
end


ActiveSupport::Notifications.subscribe("sleep_record.changed") do |_name, _start, _finish, _id, payload|
  ::SleepRecords::CleanUpHistoryCacheService.call(payload[:user])
end
