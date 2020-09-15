class AdminOrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :status, :delivery_date
  has_many :items, serializer: ItemSerializer
  belongs_to :user, serializer: UserSerializer
end