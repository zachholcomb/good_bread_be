class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :subscription_type, :delivery_day, :user_id
  has_many :shipments, serializer: ShipmentSerializer
end
