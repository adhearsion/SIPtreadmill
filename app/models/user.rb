class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone_number, :provider, :uid, :name
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
end
