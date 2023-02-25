# frozen_string_literal: true

class OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_cart, only: %i[create]

  def index
    if stale? @orders
      @orders = current_customer.orders.includes(:admin_user).limit(10)

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
    # @order.items << array
    OrderItem.upsert_all(array)

    # CartItem.destroy_all(cart_id: @cart.id)
    @cart.destroy!

    render json: { okay: true, message: "Order created" }, status: :created
  end

  private

  def set_cart
    @cart = Cart.find(params[:cart_id])
  end
end
