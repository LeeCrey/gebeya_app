# frozen_string_literal: true

ActiveAdmin.register ProductComment, namespace: "shops" do
  config.filters = false
  menu false

  actions :all, except: %i[edit update destroy new]

  includes([:customer])

  index do
    column :id
    column :body
    column :customer
    # column :product

    actions
  end

  ## show page
  # show do
  #   attributes_table do
  #     row :name
  #     row :category
  #     row :price
  #     row :origin
  #     row :quantity
  #     row :description
  #     row :discount
  #     row :images do |product|
  #       if product.images.attached?
  #         image_tag product.images.attachments.first
  #       end
  #     end
  #   end
  # end

  # Controller
  controller do
    private

    # def find_resource
    #   scoped_collection.where(product_id: params[:product_id]).first!
    # end

    def scoped_collection
      end_of_association_chain.where(product_id: params[:product_id])
    end
  end
end
