# frozen_string_literal: true

ActiveAdmin.register AdminUser, as: "Shops" do
  menu if: proc { current_admin_user.admin? || current_admin_user.super_admin? }

  actions :all, except: %i[new create edit update]

  # permit_params :email, :password, :password_confirmation

  # Filters
  filter :email
  filter :shop_name

  # Actions
  # index
  index do
    selectable_column
    id_column
    column :email
    column :shop_name
    column :current_sign_in_at
    column :created_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    actions
  end

  # Update in future
  show do
    attributes_table do
      row :shop_name
      row :email
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
    end
    f.actions
  end

  # Controller
  controller do
    rescue_from ActiveRecord::RecordNotFound, with: :path_to_root

    def show
      @page_title = "Shops"
    end

    private

    def path_to_root
      redirect_to admin_root_path
    end

    def scoped_collection
      end_of_association_chain.where.not(admin: true).where.not(super_admin: true)
    end
  end
end
