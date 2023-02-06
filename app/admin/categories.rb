# frozen_string_literal: true

ActiveAdmin.register Category do
  config.sort_order = "name_asc"

  menu if: proc { (current_admin_user.admin? || current_admin_user.super_admin?) }

  actions :all, except: %i[delete]
  permit_params :name, :description, :amharic, :locale

  # Filters
  filter :name
  filter :amharic

  # index actions
  index do
    selectable_column
    id_column
    column :name
    column :amharic
    column :created_at
    column :updated_at
    actions
  end
end
