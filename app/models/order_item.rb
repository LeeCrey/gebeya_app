# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order, touch: true

  # Validatons
  validates :product_id, presence: true, uniqueness: { scope: :order_id }
end
