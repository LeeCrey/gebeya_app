# frozen_string_literal: true

ActiveAdmin.register AdminUser, as: "Profile", namespace: :shops do
  menu false

  permit_params :shop_name, :longitude, :latitude, :password, :password_confirmation

  actions :all, except: %i[edit edit update destroy]

  action_item :show, only: :show do
    link_to "Edit Account", edit_admin_user_registration_path
  end

  action_item :show, only: :show do
    link_to "Delete Account", admin_user_registration_path, method: :delete, data: { confirm: "Are you sure?" }
  end

  show do
    attributes_table do
      row :shop_name
      row :email
      row :created_at
      row :updated_at
      row :products_count
      row :orders_count
      row :longitude
      row :latitude
      row :balance

      row "view location" do |shop|
        if shop.latitude && shop.longitude
          link_to "Your location", "https://my-location.org/?lat=#{shop.latitude}1&lng=#{shop.longitude}", target: "_blank"
        else
          p "Please enter your shop location unless your products wont be shown to users."
        end
      end
    end
  end

  controller do
    rescue_from ActiveRecord::RecordNotFound, with: -> { return_to_list }

    def return_to_list
      redirect_to admin_root_path
    end

    def scoped_collection
      end_of_association_chain.where(id: current_admin_user.id)
    end
  end
end
