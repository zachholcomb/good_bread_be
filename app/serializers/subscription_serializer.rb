class SubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :subscription_type, :delivery_day, :user_id
end