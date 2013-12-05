CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'] || 'test',
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'] || 'test',
  }
  config.fog_directory  = "foundry_test_tool_#{Rails.env}"
end
