require "test_helper"
require 'devise/jwt/test_helpers'

class Customer::SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @customer = customers(:one)
  end

  test "It should return error" do
    customer = { email: "lee_crey@gmail.com", passsword: "123456789" }
    post customer_session_path, params: { customer: customer }, as: :json

    assert_response :unauthorized, "Authorized with invalid data"
  end

  test "It login" do
    # customer = { email: @customer.email, passsword: "123456789" }
    # post customer_session_path, params: { customer: customer },
    #       headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('12345678', 'secret') },
    #        as: :json

    # assert_response :ok, "Un-Authorized with valid data"
  end

end
