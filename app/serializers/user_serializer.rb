class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :address
end
