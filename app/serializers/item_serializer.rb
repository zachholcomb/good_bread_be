class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :price, :status, :image
end