# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :customer

  scope :recent, ->(limit) do
          includes(:customer).order(id: :desc).limit(limit).references(:customer)
        end
end
