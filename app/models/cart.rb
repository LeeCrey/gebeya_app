# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :admin_user
  belongs_to :customer, touch: true

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # validates :column, presence: true
end
