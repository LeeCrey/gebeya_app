# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :name

  def name
    object.admin_user.shop_name
  end
end
