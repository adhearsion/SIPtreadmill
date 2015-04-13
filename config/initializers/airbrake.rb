Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_TOKEN']
  config.host    = ENV['AIRBRAKE_HOST'] || "api.airbrake.io"
  config.port    = 80
  config.secure  = config.port == 443
end
