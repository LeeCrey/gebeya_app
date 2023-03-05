# frozen_string_literal: true

class OrderItemsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :find_order_item, only: %i[destroy]

  # /orders/:order_id/items
  def index
    @order = Order.find(params[:order_id])

    if stale? @order
      @items = @order.items.includes(product: { images_attachments: :blob })

      expires_in 1.day

      render json: @items
    end
  end

  # DELETE items/:id
  def destroy
    @item.destroy

    order = @item.order
    if order.items.size == 0
      order.destroy
    end

    head :no_content
  end

  private

  def find_order_item
    @item = OrderItem.find(params[:id])
  end
end
