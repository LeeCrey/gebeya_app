# frozen_string_literal: true

class CommentsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_product_weigth_and_comment, only: %i[create]

  # GET products/:product_id/comments
  def index
    @comments = current_customer.comments.where(product_id: @product.id)

    render json: @comments
  end

  # POST products/:product_id/comments
  def create
    create_or_update_comment

    if @weight == 0.0
      current_customer.unvote_for @product if current_customer.voted_for? @product
    else
      @product.liked_by current_customer, vote_weight: @weight
    end

    render json: { okay: true, message: "Submitted successfully" }, status: :created
  end

  private

  def create_or_update_comment
    comment = ProductComment.find_or_initialize_by(customer_id: current_customer.id, product_id: @product.id)
    comment.body = @comment
    comment.save
  end

  def set_product_weigth_and_comment
    @product = Product.find_by(id: params[:product_id])
    @weight = params[:weight].to_i
    @comment = params[:message]
  end
end
