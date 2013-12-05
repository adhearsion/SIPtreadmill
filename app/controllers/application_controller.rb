class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_stats

  def load_stats
    @stats = Sidekiq::Stats.new
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
end
