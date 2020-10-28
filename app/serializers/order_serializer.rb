class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :status, :delivery_date, :total, :created_at
  has_many :items, serializer: ItemSerializer
end
