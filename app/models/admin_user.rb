# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :registerable

  # R/N
  with_options dependent: :destroy do
    has_many :products
    has_many :carts
    has_many :orders
  end

  # Validations
  validates :shop_name, presence: true, if: -> { shop? }

  # SCOPES
  scope :recent_shops, ->(limit) do
          where(admin: false).order(id: :desc).limit(limit)
        end

  scope :nearest, ->(lat, long) {
          find_by_sql("
            SELECT id, geodistance(latitude, longitude, #{lat}, #{long}) * 1.609344 as distance FROM admin_users
            WHERE(longitude IS NOT NULL AND latitude IS NOT NULL AND admin = false) ORDER BY distance ASC LIMIT 20")
        }

  def name
    return shop_name if shop?

    email
  end

  def shop?
    !(admin? || super_admin?)
  end
end
