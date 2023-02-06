# frozen_string_literal: true

class Customers::UnlocksController < Devise::UnlocksController
  protect_from_forgery with: :null_session
  respond_to :json

  # POST /resource/unlock
  # @Override
  def create
    self.resource = resource_class.send_unlock_instructions(resource_params)

    msg = I18n.t("devise.unlocks.send_paranoid_instructions")
    render json: { message: msg }, status: :created
  end

  private

  # @Override
  def respond_with(resource, opt = {})
    locale = resource.errors.any? ? I18n.t("unlock_token") : flash[:notice]

    render json: { message: locale }, status: opt[:status]
  end
end
