# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  cache key: "product", expires_in: 3.hours

  attributes :id, :name, :description, :origin, :quantity, :rates, :photos, :price, :discount

  def rates
    # 1.5
    object.weighted_average
    # hash = object.votes_for.group_by { |v| v.vote_weight }.transform_values! { |v| v.count }
    # totalPeople = hash.keys.count
    # return 0.0 if totalPeople.zero?

    # value = hash.map { |k, v| k * v }.sum
    # value.to_f / totalPeople
  end

  def photos
    [object.images.first.url]
  end
end
