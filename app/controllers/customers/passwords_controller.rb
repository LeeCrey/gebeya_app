# frozen_string_literal: true

class Customers::PasswordsController < Devise::PasswordsController
  protect_from_forgery with: :null_session
  respond_to :json

  # Overriding
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    msg = I18n.t("devise.passwords.send_paranoid_instructions")
    render json: { message: msg }, status: :created
  end

  # Overriding
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    changed = false
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      changed = true
    end

    respond_to do |format|
      if changed
        flash[:notice] = I18n.t("devise.passwords.updated_not_active")
        format.html { redirect_to root_url, notice: flash[:notice] }
        format.json { render json: { okay: true, message: flash[:notice] }, status: :created }
      else
        flash[:alert] = resource.errors
        format.html { render :edit, status: :unprocessable_entity, alert: flash[:alert] }
        format.json { render json: { okay: false, message: flash[:alert] }, status: :unprocessable_entity }
      end
    end
  end

  private

  def respond_with(resource, _opts = {})
    debugger
    if flash[:alert]
      render json: { okay: false, message: flash[:alert] }, status: :unprocessable_entity
    elsif flash[:notice]
      render json: { okay: true, message: flash[:notice] }, status: :created
    end
  end
end
