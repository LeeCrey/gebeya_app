# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :payment_status, :name, :latitude, :longitude

  def name
    object.admin_user.shop_name
  end

  def payment_status
    object.status.to_s.titleize
  end

  def latitude
    object.admin_user.latitude
  end

  def longitude
    object.admin_user.longitude
  end
end
