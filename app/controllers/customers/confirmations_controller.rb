# frozen_string_literal: true

class Customers::ConfirmationsController < Devise::ConfirmationsController
  protect_from_forgery with: :null_session
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if "POST" == request.method
      msg = I18n.t("devise.confirmations.send_paranoid_instructions")
    else
      if resource.errors.any?
        msg = resource.errors.first.message
      else
        msg = flash[:notice]
      end
    end

    render json: { message: msg }, status: :created
  end
end
