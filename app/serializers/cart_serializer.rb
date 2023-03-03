# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude

  def name
    object.admin_user.name
  end
  
  def latitude
    object.admin_user.latitude
  end

  def longitude
    object.admin_user.longitude
  end
end
