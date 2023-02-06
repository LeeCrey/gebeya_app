# frozen_string_literal: true

class VotesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!
  before_action :set_product, only: %i[create]

  # POST products/:product_id/vote
  def create
    if current_customer.voted_for? @product
      @product.liked_by current_customer, vote_weight: params[:weight]

      head :no_content
    else
      render json: { okay: false, message: "Already voted for product" }, status: :bad_request
    end
  end

  # PATCH votes/:id
  def update
  end

  # DELETE votes/:id
  def destroy
  end

  private

  def set_product
    @product = Produc.find_by(id: params[:product_id])
  end
end
