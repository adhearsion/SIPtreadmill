CarrierWave.configure do |config|
  if ENV['STORAGE_TYPE'] == 's3'
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'] || 'test',
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'] || 'test',
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET'] || "sip-treadmill-#{Rails.env}"
  else
    config.storage = :file
    config.root = ENV['FILE_PATH'] || File.expand_path("../../public", File.dirname(__FILE__))
  end
end
