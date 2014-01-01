class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def att
    @user = User.find_or_create_from_auth_hash :att, request.env["omniauth.auth"]

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "AT&T Foundry") if is_navigational_format?
    end
  end

  def github 
    @user = User.find_or_create_from_auth_hash :github, request.env["omniauth.auth"]

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
    end
  end

end
