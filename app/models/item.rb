class Item < ApplicationRecord
  has_many :shipment_items
  has_many :shipments, through: :shipment_items
  has_many :order_items
  has_many :orders, through: :order_items
  validates :name, :price, presence: true
end
