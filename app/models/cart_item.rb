# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, touch: true

  # Validations
  validates :product_id, presence: true, uniqueness: { scope: :cart_id }
end
