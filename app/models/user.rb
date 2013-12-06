class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone_number, :provider, :uid, :name, :authentication_token
  devise :omniauthable, :omniauth_providers => [:att, :github]

  has_many :targets
  has_many :profiles
  has_many :scenarios
  has_many :test_runs

  before_update do
    self.admin_mode = self.admin if self.admin_changed?
    true
  end

  def self.find_or_create_from_auth_hash(type, auth_hash)
    user_info = auth_hash.info
    user = self.where(uid: auth_hash.uid).first
    unless user
      case type
      when :att
        user = new(
          first_name: user_info.first_name,
          last_name: user_info.last_name,
          email: user_info.email,
          phone_number: user_info.phone_number,
          provider: auth_hash.provider,
          uid: auth_hash.uid
        )
        user.save!
      when :github
        user = new(
          name: user_info.name,
          email: user_info.email,
          uid: auth_hash.uid
        )
        user.save!
      end
    end
    user
  end

  def full_name
    return self.name || "#{self.first_name} #{self.last_name}"
  end

  def ensure_authentication_token
    unless self.authentication_token.present?
      self.new_auth_token!
    end
  end

  def new_auth_token!
    self.authentication_token = generate_authentication_token
    self.save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
