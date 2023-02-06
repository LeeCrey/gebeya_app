# frozen_string_literal: true

class ProfileController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :authenticate_customer!

  #  /customer
  def show
    render json: current_customer
  end
end
