class HomeController < ApplicationController
  def index
  end

  def toggle_admin
    authorize! :toggle_admin_mode, :current_user

    current_user.admin_mode = !current_user.admin_mode
    current_user.save

    redirect_to :back
  end
end
