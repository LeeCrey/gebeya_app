# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    object.admin_user.name
  end
end
