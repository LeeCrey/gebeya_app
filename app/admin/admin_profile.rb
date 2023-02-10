# frozen_string_literal: true
# Bad solution btw

ActiveAdmin.register AdminUser, as: "profile", namespace: :shops do
  menu false

  permit_params :shop_name, :email, :password, :password_confirmation

  show do
    attributes_table do
      row :shop_name
      row :email
      row :created_at
      row :updated_at
      row :products_count
      row :orders_count
    end
  end

  form do |f|
    f.inputs do
      f.input :shop_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :current_password
    end
    f.actions
  end

  controller do
    rescue_from ActiveRecord::RecordNotFound, with: -> { return_to_list }

    def index
      # super
      redirect_to edit_admin_shop_path(current_admin_user)
    end

    private

    def return_to_list
      redirect_to admin_root_path
    end

    def scoped_collection
      end_of_association_chain.where(id: current_admin_user.id)
    end
  end
end
