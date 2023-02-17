# frozen_string_literal: true
# Bad solution btw

ActiveAdmin.register AdminUser, as: "profile", namespace: :shops do
  menu false

  show do
    attributes_table do
      row :shop_name
      row :email
      row :created_at
      row :updated_at
      row :products_count
      row :orders_count
      row :merchant_id
      row :longitude
      row :latitude

      row "view location" do |shop|
        if shop.latitude && shop.longitude
          link_to "Your location", "https://my-location.org/?lat=#{shop.latitude}1&lng=#{shop.longitude}", target: "_blank"
        else
          p "Please enter your shop location unless your products wont be shown to users."
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :shop_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :current_password
      f.input :merchant_id
      f.input :longitude
      f.input :latitude
    end
    f.actions
  end

  controller do
    rescue_from ActiveRecord::RecordNotFound, with: -> { return_to_list }

    def index
      # super
      redirect_to action: "edit"
      # redirect_to edit_admin_shop_path(current_admin_user)
    end

    def return_to_list
      redirect_to admin_root_path
    end

    def scoped_collection
      end_of_association_chain.where(id: current_admin_user.id)
    end

    private
    def permitted_params
      hash = params.require(:admin_user).permit(
        :shop_name, :email, :current_password,
        :password, :password_confirmation, :merchant_id, :longitude, :latitude)
      
      hash.reject { |k,v| v.empty? or v.nil? }
    end
  end
end
