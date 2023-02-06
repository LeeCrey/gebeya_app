# frozen_string_literal: true

class ProductComment < ApplicationRecord
  belongs_to :customer
  belongs_to :product, touch: true

  # Validations
  validates :body, presence: true
end
