class OrderItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :quantity
  belongs_to :item, serializer: ItemSerializer
end
