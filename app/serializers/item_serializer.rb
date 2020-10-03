class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :price, :status

  attribute :image do |object|
    object.get_image_url if object.image.attached?
  end
end