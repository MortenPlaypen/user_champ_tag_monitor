class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
    #UserMailer.new_user
  end

  def new
    super
  end

  def edit
    super
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :helpscout_token)
  end
end
