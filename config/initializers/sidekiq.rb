redis_host = ENV['REDIS_SIDEKIQ_URL'] || 'redis://localhost:6379/0'

Sidekiq.configure_server do |config|
  config.redis = { url:  redis_host }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_host }
end

