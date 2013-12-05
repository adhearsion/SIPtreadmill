require 'json'

if ENV.has_key? 'VCAP_SERVICES'
  Rails.logger.info "CloudFoundry environment detected."

  begin
    vcap = JSON.parse ENV['VCAP_SERVICES']

    # Redis
    if vcap.has_key? 'redis-2.6'
      redis = vcap['redis-2.6'].first['credentials']
      ENV['REDIS_URL'] = "redis://#{redis['name']}:#{redis['password']}@#{redis['host']}:#{redis['port']}/"
    end

  rescue => e
    Rails.logger.warn "Failed to parse CloudFoundry environment: #{e.message}"
  end

end
