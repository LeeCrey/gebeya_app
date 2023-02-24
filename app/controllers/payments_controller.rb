# frozen_string_literal: true

class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_order

  #   /orders/:order_id/payments
  def create
    if @order.paid?
      render json: { okay: false, message: "Order was paid before" }, status: :unprocessable_entity
    else
      total = @order.items.includes(:product).sum("order_items.quantity * products.price")
      balance = customer.balance
      if total > customer.balance
        render json: { okay: false, message: "Your balance is insufficient" }, status: :unprocessable_entity
      else
        # There should be transaction here
        customer.balance -= total # withdraw
        admin_user = order.admin_user
        admin_user.balance += total # deposit
        admin_user.save
        # end of transaction
        render json: { okay: true, message: "Payment successfull" }, status: :created
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end
