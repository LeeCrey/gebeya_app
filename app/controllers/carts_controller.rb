# frozen_string_literal: true

class CartsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  # GET  /cart
  def index
    if stale?(last_modified: current_customer.updated_at, public: true)
      @carts = current_customer.carts.includes(:admin_user).references(:admin_user)

      expires_in 1.day

      render json: { carts: ActiveModelSerializers::SerializableResource.new(@carts, each_serializer: CartSerializer) }
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
