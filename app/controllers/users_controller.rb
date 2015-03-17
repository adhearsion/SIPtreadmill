class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    authorize! :make_others_admin, :current_user
  end

  def update
    authorize! :make_others_admin, :current_user
    @user.admin = params[:user][:admin]
    logger.info params

    if @user.save
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  def generate_token
    @user = User.find params[:id]
    @user.new_auth_token!

    redirect_to @user, notice: 'Authentication Token successfully generated.'
  end
end