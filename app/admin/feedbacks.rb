# frozen_string_literal: true

ActiveAdmin.register Feedback do
  menu if: proc { (current_admin_user.admin? || current_admin_user.super_admin?) }
  actions :all, except: %i[new edit update]

  includes :customer

  filter :customer
end
