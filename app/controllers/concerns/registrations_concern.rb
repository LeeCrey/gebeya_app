# frozen_string_literal: true

module RegistrationsConcern
  def respond_with(resource, _opts = {})
    if resource.errors.empty? and resource.persisted?
      request_success
    else
      request_failed
    end
  end

  def request_success
    message = flash[:notice] ||= flash[:alert]

    render json: { okay: true, message: message }, status: :created
  end

  def request_failed
    render json: { okay: false, errors: resource.errors }, status: :unprocessable_entity
  end
end
