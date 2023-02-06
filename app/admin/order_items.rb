# frozen_string_literal: true

ActiveAdmin.register OrderItem, namespace: "shops" do
  config.filters = false
  menu false
  actions :all, except: %i[new edit update destroy]

  includes([:product])

  index do
    column :id
    column :product
    column :quantity
    column :created_at
  end

  controller do
    private

    def scoped_collection
      end_of_association_chain.includes(:product).where(order_id: params[:order_id])
    end
  end
end
