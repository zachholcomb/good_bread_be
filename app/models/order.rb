class Order < ApplicationRecord
  after_initialize :set_status

  validates :status, :delivery_date, presence: true
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user
  enum status: %w(Pending Shipped Delivered)

  def set_status
    self.status ||= 0
  end
end
