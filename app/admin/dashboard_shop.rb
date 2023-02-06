# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard", namespace: "shops" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Products" do
          ul do
            Product.recent(5, current_admin_user).map do |product|
              li link_to(product, shops_product_path(product))
            end
          end
        end
      end
    end

    strong { link_to "View all products", shops_products_path }
  end
end
