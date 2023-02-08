# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  cache key: "product", expires_in: 3.hours

  attributes :id, :name, :description, :origin, :quantity, :rates, :photos, :price, :discount

  def rates
    object.weighted_average
  end

  def photos
    [object.images.first.url]
  end
end
