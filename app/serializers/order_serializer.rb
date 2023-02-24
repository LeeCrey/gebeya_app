# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :payment_status, :name

  def name
    object.admin_user.shop_name
  end

  def payment_status
    object.status.to_s.titleize
  end
end
