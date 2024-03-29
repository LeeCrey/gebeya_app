# frozen_string_literal: true

class ProfileController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  include ActionView::Helpers::NumberHelper

  #  /customer
  def show
    render json: current_customer
  end

  # DELETE /search_histories
  def search_history
    current_customer.search_histories.destroy_all

    head :no_content
  end

  def balance
    render json: { balance: number_to_currency(current_customer.balance) }
  end
end
