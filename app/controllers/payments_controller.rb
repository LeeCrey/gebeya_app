# frozen_string_literal: true

# For demo purpose only
# Integrate your own payment system
class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_order, only: %i[create]

  # POST  /orders/:order_id/payments
  def create
    if @order.paid?
      render json: { okay: false, message: I18n.t("payment.paid") }, status: :unprocessable_entity
    else
      customer = current_customer

      if @order.customer_id != customer.id
        render json: { okay: false, message: "You can not pay some ones order" }, status: :unprocessable_entity and return
      end

      @items = @order.items.includes(:product)

      out_of_stock_items = @items.where(product: { quantity: 0 })

      if out_of_stock_items.size == 0
        qry = "order_items.quantity * CASE WHEN products.discount IS NULL THEN products.price ELSE products.price - products.discount END"
        total = @items.sum(qry)
        balance = customer.balance
  
        if total > customer.balance
          render json: { okay: false, message: I18n.t("payment.insuffient") }, status: :unprocessable_entity
        else
          do_transaction(customer, total, @items)
  
          render json: { okay: true, message: I18n.t("payment.success") }, status: :created
        end
      else
        names = ->(x) { x.product.name }
        product_names = out_of_stock_items.map(&names).join(',')
        msg = product_names + " is out of stock in the shop. Please find this product is another shop."
        render json: { okay: false, message: msg }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def do_transaction(customer, total, items)
    ActiveRecord::Base.transaction do
      customer.balance -= total # withdraw
      admin_user = @order.admin_user
      admin_user.balance += total # deposit
      customer.save!
      admin_user.save!
      @order.paid!
      ids = {}
      # causing N+1 query, fix this if you can.
      items.map do |x|
        p = x.product
        ids[p.id] = { quantity: (p.quantity - x.quantity) }
      end
      Product.update(ids.keys, ids.values)
    end
  end
end
