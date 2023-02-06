# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  # Valdiations
  validates :name, :amharic, presence: true

  # Methods
  def to_s
    name
  end
end
