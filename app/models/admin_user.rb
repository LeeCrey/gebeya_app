# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :registerable

  # R/N
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Validations
  validates :shop_name, presence: true, if: -> { shop? }

  # SCOPES
  scope :recent_shops, ->(limit) do
          where(admin: false).order(id: :desc).limit(limit)
        end

  scope :nearest_with_location, ->(lat, long) {
          find_by_sql("
            SELECT id, floor(geodistance(latitude, longitude, #{lat}, #{long})) distance FROM admin_users
            where(longitude is not null and latitude is not null and admin = false) order by distance asc limit 20")
        }

  def name
    return shop_name if shop?

    email
  end

  def shop?
    !(admin? || super_admin?)
  end
end
