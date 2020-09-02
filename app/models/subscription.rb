class Subscription < ApplicationRecord
  validates :delivery_day, :subscription_type, presence: true
  belongs_to :user
end