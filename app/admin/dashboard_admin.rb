# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Shops" do
          ul do
            AdminUser.recent_shops(5).map do |shop|
              li link_to(shop.name, admin_shop_path(shop))
            end
          end
        end
      end
      strong { link_to "View all shops", admin_shops_path }
    end

    columns do
      column do
        panel "Recent Feedbacks" do
          ul do
            Feedback.recent(5).map do |fd|
              li link_to(fd.customer, admin_feedback_path(fd))
            end
          end
        end
      end
      strong { link_to "View all feedbacks", admin_feedbacks_path }
    end
  end
end
