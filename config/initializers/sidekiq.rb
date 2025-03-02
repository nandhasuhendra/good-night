redis_host = ENV['REDIS_HOST'] || 'localhost:6379'

Sidekiq.configure_server do |config|
  config.redis = { url:  "redis://#{redis_host}/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_host}/0" }
end

