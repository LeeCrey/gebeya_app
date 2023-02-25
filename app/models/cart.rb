# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :admin_user
  belongs_to :customer

  has_many :items, class_name: "CartItem", dependent: :destroy
end
