# frozen_string_literal: true

class CustomerAccountDeleteJob < ApplicationJob
  include Sidekiq::Worker

  def perform
    # resource.destroy
    # Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
  end
end
