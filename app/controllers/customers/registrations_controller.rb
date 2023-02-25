# frozen_string_literal: true

class Customers::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session
  respond_to :json

  # POST /customers
  def create
    build_resource(sign_up_params)

    resource.save

    message = I18n.t("devise.registrations.signed_up_but_unconfirmed")

    # I want user should check his/her mail rather than notifying the email is taken
    render json: { okay: true, message: message }, status: :created
  end

  private

  include RegistrationsConcern

  # Overriding
  def sign_up_params
    params.require(:customer).permit(
      :first_name, :last_name, :email,
      :password, :password_confirmation)
  end

  # Overriding
  def account_update_params
    hash = params.permit(:first_name, :last_name,
                         :current_password, :password_confirmation,
                         :password, :profile)

    hash
    # params.require(:customer).permit(
    #   :first_name, :last_name,
    #   :current_password,
    #   :password, :password_confirmation
    # )
  end
end
