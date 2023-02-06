# frozen_string_literal: true

module SessionsConcern
  def current_token
    request.env["warden-jwt_auth.token"]
  end

  # LOGIN
  def respond_with(resource, _opt = {})
    customer_signed_in? ? login_success : login_failed
  end

  def login_success
    msg = I18n.t("devise.sessions.signed_in")

    render json: { okay: true, message: msg, full_name: current_customer.full_name }
  end

  def login_failed
    error = I18n.t("devise.failure.invalid")

    render json: { okay: true, error: error }, status: :unauthorized
  end

  # LOGOUT
  def respond_to_on_destroy
    current_customer ? request_success : request_failed
  end

  def request_success
    render_json :ok, true
  end

  def request_failed
    render json: { okay: false, message: "Un-authorized request." }, status: :unauthorized
  end

  def render_json(status = :unauthorized, okay = false)
    msg = flash[:alert] ||= flash[:notice]
    render json: { okay: okay, message: msg }, status: status
  end
end
