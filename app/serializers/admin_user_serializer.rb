class AdminUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :longitude, :latitude
end
