class Shipment < ApplicationRecord
  validates :status, :delivery_date, presence: true
  belongs_to :subscription
  has_many :shipment_items
  has_many :items, through: :shipment_items 
end
