# frozen_string_literal: true

ActiveAdmin.register Customer do
  menu if: proc { current_admin_user.admin? || current_admin_user.super_admin? }

  actions :all, except: %i[new create edit update]

  config.per_page = 15

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :confirmed_at
    column :created_at
    actions
  end

  # Filters
  filter :first_name
  filter :last_name
  filter :email
end
