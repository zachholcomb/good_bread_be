class User < ApplicationRecord
  has_secure_password
  after_initialize :set_role

  has_one :subscription
  validates :name, :address, :role, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password_digest, presence: true

  def set_role
    self.role ||= 0
  end
end