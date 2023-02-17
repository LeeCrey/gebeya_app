# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer, touch: true # update last updated at
  belongs_to :admin_user

  has_many :order_items, dependent: :destroy
  # has_many :products, through: :order_items

  counter_culture :admin_user

  #
  enum :status, {
    pending: 0,
    canceled: 1,
    paid: 2,
    done: 3,
  }

  # Scopes
  scope :paid, ->(shop_id) {
          where(admin_user_id: shop_id, status: 4)
        }
end
