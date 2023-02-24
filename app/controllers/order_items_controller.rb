# frozen_string_literal: true

class OrderItemsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  # /orders/:order_id/items
  def index
    @order = Order.find(params[:order_id])

    if stale? @order
      @items = @order.items.includes(:product)

      expires_in 1.day

      render json: @items
    end
  end
end
