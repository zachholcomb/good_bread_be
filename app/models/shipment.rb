class Shipment < ApplicationRecord
  after_initialize :set_status

  validates :status, :delivery_date, presence: true
  belongs_to :subscription
  has_many :shipment_items
  has_many :items, through: :shipment_items 
  enum status: %w(Pending Shipped Delivered)

  def set_status
    self.status ||= 0
  end
end
