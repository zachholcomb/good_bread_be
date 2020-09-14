class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :status, :delivery_date
  has_many :items, serializer: ItemSerializer
end