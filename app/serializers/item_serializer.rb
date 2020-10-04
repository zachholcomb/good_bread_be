class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :price, :status, :type, :description

  attribute :image do |object|
    object.get_image_url if object.image.attached?
  end
end