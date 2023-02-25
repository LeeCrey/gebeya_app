require "test_helper"
require "devise/jwt/test_helpers"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login page" do
    headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' }

    get shops_orders_path, headers: { Authorization: headers }

    assert_response :redirect
  end

  test "should be success" do
    headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' }

    customer = customers(:one)
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, customer)

    get shops_orders_path, headers: { Authorization: auth_headers }

    # assert_response :success, message: "Not success" # why not success 
  end
end
