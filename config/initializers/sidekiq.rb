Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

if ENV.fetch('SIDEKIQ_TESTING_INLINE', false) == 'true'
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
