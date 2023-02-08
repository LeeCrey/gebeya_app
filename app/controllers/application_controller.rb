# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from I18n::InvalidLocale, with: :not_valid_locale

  def check_in_right_module
    if admin_user_signed_in?
      is_admin = current_admin_user.admin?
      # both admin and shop should update the info
      if namespace_and_class.last != "RegistrationsController"
        if from_admin_module and !is_admin
          redirect_to shops_root_path
        elsif from_shops_module and is_admin
          redirect_to admin_categories_path
        end
      end
    end
  end

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  private

  def set_locale
    lkl = params[:locale]
    lkl = :en if lkl.nil? or lkl.empty?
    I18n.locale = lkl
  end

  def from_admin_module
    namespace_and_class.first == "Admin"
  end

  def from_shops_module
    namespace_and_class.first == "Shops"
  end

  def namespace_and_class
    @namespace_and_class ||= self.class.to_s.split(/\::/)
  end

  def record_not_found
    render json: { okay: false, message: "Record not found" }, status: :not_found
  end

  def not_valid_locale
    render json: { okay: false, message: "Locale is not valid" }, status: :unprocessable_entity
  end
end
