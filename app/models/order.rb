# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :admin_user

  has_many :order_items, dependent: :destroy
  # has_many :products, through: :order_items

  counter_culture :admin_user

  #
  enum :status, {
    saved: 0,
    pending: 1,
    canceled: 2,
    paid: 3,
    done: 4,
  }

  # Scopes
  scope :paid, ->(shop_id) {
          where(admin_user_id: shop_id, status: 4)
        }
end
