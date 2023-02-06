# frozen_string_literal: true

class OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_cart, only: %i[create]

  def index
    @orders = current_customer.orders.includes(:admin_user).limit(10)

    render json: @orders
  end

  def show
  end

  # POST /carts/:cart_id/order
  def create
    @order = current_customer.orders.find_or_create_by(admin_user_id: @cart.admin_user_id)
    array = []
    @cart.cart_items.each do |item|
      array << { order_id: @order.id, product_id: item.product_id, quantity: item.quantity }
    end
    OrderItem.upsert_all(array)

    @cart.destroy

    render json: { okay: true, message: "Order created" }, status: :created
  end

  private

  def set_cart
    @cart = Cart.find(params[:cart_id])
  end
end
