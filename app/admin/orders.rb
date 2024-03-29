# frozen_string_literal: true

ActiveAdmin.register Order, namespace: "shops" do
  config.filters = false
  config.per_page = 10

  menu if: proc { !(current_admin_user.admin? || current_admin_user.super_admin?) }

  actions :all, except: %i[new edit update destroy]

  includes([:customer])

  scope "All" do |orders|
    current_admin_user.orders
  end

  # # Scopes
  scope "Pending", group: :status do
    current_admin_user.orders.pending
  end

  scope "Paid", group: :status do
    current_admin_user.orders.paid
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
