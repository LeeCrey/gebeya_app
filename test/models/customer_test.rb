require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  setup do
    @first = customers(:one)
  end

  test "Data field validation" do
    customer = Customer.new
    assert_not customer.save, "Saved the customer without data"
  end

  test "Password length validation" do
    customer = Customer.new(first_name: "Lee", last_name: "Crey")
    customer.password = "12345"
    customer.password_confirmation = "12345"
    customer.email = "valid@gmail.com"

    assert_not customer.valid?, "Valid with invalid password length"
  end

  test "shoud raise error" do
    customer = Customer.new(first_name: "Lee", last_name: "Crey")
    customer.password = "123456"
    customer.password_confirmation = "123456"
    customer.email = @first.email

    assert_raise ActiveRecord::RecordInvalid do
      customer.save!
    end
  end

  test "should be valid" do
    customer = Customer.new
    customer.first_name = "Lee"
    customer.last_name = "Crey"
    customer.password = "123456"
    customer.password_confirmation = "123456"
    customer.email = "valid@gmail.com"

    assert customer.valid?, "Invalid user"
  end
end
