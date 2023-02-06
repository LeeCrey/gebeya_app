# froze_string_literal: true

class Customer < ApplicationRecord
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  # R/S
  with_options dependent: :destroy do
    has_many :carts
    has_many :orders
    has_many :feedbacks
    has_many :comments, class_name: "ProductComment"
    has_one_attached :profile
    has_many :search_histories
  end
  acts_as_voter

  # Validations
  validates :first_name, :last_name, presence: true

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end
end
