# frozen_string_literal: true

ActiveAdmin.register Customer do
  menu if: proc { current_admin_user.admin? || current_admin_user.super_admin? }

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
