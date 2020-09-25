class Item < ApplicationRecord
  after_initialize :set_defaults

  has_many :shipment_items
  has_many :shipments, through: :shipment_items
  has_many :order_items
  has_many :orders, through: :order_items
  validates :name, :price, presence: true
  enum status: %w(Active Inactive)

  def set_defaults
    self.status ||= 0
  end
end
