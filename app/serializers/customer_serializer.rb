class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :profile_image_url

  def profile_image_url
    if object.profile.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.profile)
    else
      "https://www.pngfind.com/pngs/m/470-4703547_icon-user-icon-hd-png-download.png"
    end
  end
end
