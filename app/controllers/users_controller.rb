class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    @user.admin = params[:user][:admin]
    logger.info params

    if @user.save
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end
end