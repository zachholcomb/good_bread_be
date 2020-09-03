class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :price
end