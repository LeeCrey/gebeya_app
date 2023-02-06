# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :id, :name, :merchant_id

  def merchant_id
    object.admin_user.merchant_id
  end

  def name
    object.admin_user.name
  end
end
