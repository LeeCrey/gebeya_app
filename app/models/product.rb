# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :admin_user

  counter_culture :admin_user

  with_options dependent: :destroy do
    has_many_attached :images
    has_many :comments, class_name: "ProductComment"
  end

  acts_as_votable cacheable_strategy: :update_columns

  # Methods
  def to_s
    name
  end

  include ProductConcern
end
