# frozen_string_literal: true

# For demo purpose only
# Integrate your own payment system
class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_order

  #   /orders/:order_id/payments
  def create
    if @order.paid?
      render json: { okay: false, message: I18n.t("payment.paid") }, status: :unprocessable_entity
    else
      customer = current_customer
      total = @order.items.includes(:product).sum("order_items.quantity * products.price")
      balance = customer.balance
      if total > customer.balance
        render json: { okay: false, message: I18n.t("payment.insuffient") }, status: :unprocessable_entity
      else
        do_transaction(customer)

        render json: { okay: true, message: I18n.t("payment.success") }, status: :created
      end
    end
  end

  private

  def set_order
    @order = Order.find!(params[:order_id])
  end

  def do_transaction(customer)
    ActiveRecord::Base.transaction do
      customer.balance -= total # withdraw
      admin_user = @order.admin_user
      admin_user.balance += total # deposit
      customer.save!
      admin_user.save!
      @order.paid!
    end
  end
end
