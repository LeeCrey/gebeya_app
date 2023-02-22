# frozen_string_literal: true

class CartItemsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_cart, only: %i[index]

  # GET /cart/:cart_id/cart_item
  def index
    # @items = @cart.cart_items.includes(:product).references(:product)
    # n + 1 query optimize for product image

    if stale? @cart
      @items = CartItem.includes(:cart, :product).where(cart: { id: @cart.id })

      expires_in 1.day

      render json: @items
    end
  end

  # PUT/PATCH  /cart_item/:id
  def update
    quantity = params[:quantity].to_i
    if quantity.zero?
      render json: { okay: false, message: "Quantity can not be zero" }, status: :bad_request and return
    end

    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(quantity: quantity)
      render json: { okay: true, message: "Cart updated successfully" }, status: :ok
    else
      render json: { okay: false, errors: @cart_item.errors }, status: :unprocessable_entity
    end
  end

  # POST /cart_items
  def create
    @product = Product.find(params[:product_id])
    shop_id = @product.admin_user_id
    @cart = current_customer.carts.find_or_create_by(admin_user_id: shop_id)
    @item = @cart.cart_items.new(product_id: @product.id)
    @item.quantity = params[:quantity].to_i

    if @item.save
      render json: { okay: true, message: I18n.t("cart.added") }, status: :created
    else
      render json: { okay: false, errors: @item.errors }, status: :bad_request
    end
  end

  # DELETE /cart_item/:id
  def destroy
    CartItem.destroy_by(id: params[:id])

    head :no_content
  end

  private

  def set_cart
    @cart = Cart.find(params[:cart_id])
  end

  def cart_item_params
    params.require(:product).permit(:id)
  end
end
