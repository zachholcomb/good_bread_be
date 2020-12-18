class SubscriptionAllergy < ApplicationRecord
  belongs_to :subscription
  belongs_to :allergy
end