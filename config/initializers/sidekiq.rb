Sidekiq.configure_server do |config|
  config.options[:concurrency] = 1
end
