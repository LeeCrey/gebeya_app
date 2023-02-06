# frozen_string_literal: true

class SearchHistory < ApplicationRecord
  belongs_to :customer

  # Validations
  validates :body, presence: true, uniqueness: true
end
