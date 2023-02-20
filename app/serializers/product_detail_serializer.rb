# frozen_string_literal: true

class ProductDetailSerializer < ActiveModel::Serializer
  cache key: "product", expires_in: 3.hours

  attributes :id, :name, :description, :origin, :quantity, :rates, :photos, :price, :discount, :total_votes

  def rates
    object.weighted_average
  end

  def photos
    object.images.map(&:url)
  end

  def total_votes
    object.votes_for.count
  end

  belongs_to :admin_user
end
