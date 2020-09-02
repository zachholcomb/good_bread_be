class User < ApplicationRecord
  has_secure_password

  has_one :subscription
  validates :name, :address, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password_digest, presence: true
end