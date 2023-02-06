# frozen_string_literal: true

class FeedbackController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  # POST /feedbacks
  def create
    fdb = current_customer.feedbacks.new(body: params[:String])

    if fdb.save
      render json: { okay: true, message: "You successfully sent feedback" }, status: :created
    else
      render json: { okay: false, message: "Could not able to sent" }, status: :unprocessible_entity
    end
  end
end
