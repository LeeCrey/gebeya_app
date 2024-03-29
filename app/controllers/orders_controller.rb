# frozen_string_literal: true

class OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_cart, only: %i[create]

  def index
    @orders = current_customer.orders.includes(:admin_user)

    if stale? @orders
      expires_in 3.day

      render json: @orders
    end
  end

  # POST /carts/:cart_id/order
  def create
    @order = current_customer.orders.new(admin_user_id: @cart.admin_user_id)
    @order.save
    array = []
    @cart.items.each do |item|
      array << { order_id: @order.id, product_id: item.product_id, quantity: item.quantity }
    end
    OrderItem.upsert_all(array)

    @cart.destroy!

    render json: { okay: true, message: "Order created" }, status: :created
  end

  private

  def set_cart
    @cart = Cart.find(params[:cart_id])
  end
end
