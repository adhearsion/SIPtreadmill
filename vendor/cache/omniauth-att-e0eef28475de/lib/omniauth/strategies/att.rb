require 'multi_json'
require 'omniauth'
require 'omniauth-oauth2'
require 'omniauth/strategies/oauth2'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'
require 'json'
require 'uri'

module OmniAuth
  module Strategies
    class Att < OmniAuth::Strategies::OAuth2
      option :name, "att"

      option :client_options, {
        :site           => ENV['ATT_BASE_DOMAIN'] || 'https://auth.tfoundry.com',
        :authorize_url  => '/oauth/authorize',
        :saml_base_path => nil,
        :token_url      => '/oauth/token.json',
        :raise_errors   => true
      }

      option :token_params, {
        :parse => :json
      }

      # These are called after authentication has succeeded. 
      uid{ raw_info['uid'] }

      info do
        prune!({
          :name               => raw_info['info']['name'],
          :phone_number       => raw_info['info']['phone_number'],
          :email              => raw_info['info']['email'],
          :first_name         => raw_info['info']['first_name'],
          :last_name          => raw_info['info']['last_name']
        })
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.expires?
        hash.merge!('expires_at' => access_token.expires_at) if access_token.expires?
        hash.merge!('expires' => access_token.expires?)
        hash
      end

      def full_host
        ENV['RACK_ENV'] == 'production' ? super.gsub('http:', 'https:') : super
      end

      def request_phase
        options[:authorize_params][:response_type] ||= 'code'
        if options.client_options[:saml_base_path]
          redirect saml_url
        else
          super
        end
      end

      def raw_info
        @raw_info ||= access_token.get('/me.json').parsed
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def saml_url
        auth_url = client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
        URI.parse(options.client_options[:site]).tap do |url|
          url.path = options.client_options[:saml_base_path]
          url.query = URI.encode_www_form({:origin => auth_url})
        end.to_s
      end
    end
  end
end


OmniAuth.config.add_camelization 'att', 'Att'
