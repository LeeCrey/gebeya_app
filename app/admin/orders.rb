# frozen_string_literal: true

ActiveAdmin.register Order, namespace: "shops" do
  config.filters = false
  config.per_page = 10

  menu if: proc { !(current_admin_user.admin? || current_admin_user.super_admin?) }

  actions :all, except: %i[new edit update destroy]

  includes([:customer])

  # # Scopes
  scope "Saved", group: :status do |orders|
    orders.where(status: :saved)
  end

  scope "Paid", group: :status do |orders|
    orders.where(status: :paid)
  end

  scope "Cancelled", group: :status do |orders|
    orders.where(status: :canceled)
  end

  # index page
  index do
    column :id
    column :customer
    column :status
    column :created_at
    column :items do |order|
      div do
        link_to "View", shops_order_items_path(order_id: order)
      end
    end
  end

  # Controller
  controller do
    private

    def scoped_collection
      end_of_association_chain.includes(:customer).where(admin_user_id: current_admin_user.id)
    end
  end
end
