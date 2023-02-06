# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  respond_to :json

  private

  include SessionsConcern
end
