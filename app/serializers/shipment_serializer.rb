class ShipmentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :status, :delivery_date, :subscription_id
  has_many :items, serializer: ItemSerializer
end