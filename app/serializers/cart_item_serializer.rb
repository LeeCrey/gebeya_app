class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product, :item_image

  def product
    object.product.slice(:id, :name, :price, :discount, :quantity)
  end

  def item_image
    object.product.images&.first.url
    # Rails.application.routes.url_helpers.rails_blob_url(object.product.images&.first)
  end
end
