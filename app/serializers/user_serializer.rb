class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :address, :state, :city, :zip, :role
end
