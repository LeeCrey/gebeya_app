# frozen_string_literal: true

class CartsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  # GET  /cart
  def index
    @carts = current_customer.carts.includes(:admin_user)

    if stale? @carts
      expires_in 3.day

      render json: @carts
    end
  end

  # DELETE /cart/:id
  def destroy
    Cart.destroy_by(id: params[:id])

    head :no_content
  end

  # DELETE /cart
  def clear
    Cart.destroy_all

    head :no_content
  end
end
