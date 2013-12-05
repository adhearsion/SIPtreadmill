require "spec_helper"

module HelperMethods
  def login_user
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  def set_omniauth(opts = {})
    default = {
        uid: 'att-abcd1234',
        provider: 'att',
        credentials: {token: 'zyxwvut4321'},
        info: {
          first_name: 'Test',
          last_name: 'User',
          email: 'test@example.com',
          phone_number: '14045551234'
        }
      }

    credentials = default.merge(opts)
    provider = credentials[:provider]
    user_hash = credentials[provider]

    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[provider] = {
      'uid' => credentials[:uid]
    }
  end

  def set_invalid_omniauth(opts = {})

    credentials = { :provider => :facebook,
      :invalid  => :invalid_crendentials
    }.merge(opts)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
  end

  def login_with_oauth
    set_omniauth
    visit user_omniauth_authorize_path :att
  end
end