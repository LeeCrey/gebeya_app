# frozen_string_literal: true

class Shops::RegistrationsController < ActiveAdmin::Devise::RegistrationsController
  private

  # Overriding
  def sign_up_params
    params.require(:admin_user).permit(:shop_name, :email, :password, :password_confirmation)
  end

  # Overriding
  def account_update_params
    params.require(:admin_user).permit(:shop_name, :longitude, :latitude,
                                       :current_password, :password, :password_confirmation)
  end
end
