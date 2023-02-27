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

  # Overriding
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      render json: { okay: true, message: I18n.t("devise.registrations.updated") }, status: :created
    else
      clean_up_passwords resource
      set_minimum_password_length

      render json: { okay: false, message: resource.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  # Overriding
  def destroy
    pwd = params[:password]

    render json: { okay: false, message: "Password required to ensure" } and return if !pwd

    if current_customer.valid_password?(params[:password])
      # CustomerAccountDeleteJob.perform_async
      resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

      render json: { okay: true, message: I18n.t("devise.registrations.destroyed") }, status: :accepted
    else
      render json: { okay: false, message: I18n.t("password.do_not_match") }, status: :unprocessable_entity
    end
  end

  private

  include RegistrationsConcern

  # Overriding
  def sign_up_params
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  # def respond_with(resource, _opts = {})
  #   if flash[:alert]
  #     render json: { okay: false, message: flash[:alert] }, status: :unprocessable_entity
  #   elsif flash[:notice]
  #     render json: { okay: true, message: flash[:notice] }, status: :created
  #   end
  # end
end
