class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_stats, :guest_user_auth

  def load_stats
    @stats = Sidekiq::Stats.new
  end

  def guest_user_auth
    if ENV['OMNIAUTH_TYPE'] == 'none'
      sign_in(User.where(admin: true).first)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
end
