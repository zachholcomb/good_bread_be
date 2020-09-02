class ShipmentItem < ApplicationRecord
  belongs_to :item
  belongs_to :shipment
end
