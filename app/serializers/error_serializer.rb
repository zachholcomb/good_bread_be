class ErrorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :message
end
