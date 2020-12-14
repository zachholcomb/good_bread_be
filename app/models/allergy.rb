class Allergy < ApplicationRecord
  has_many :subscription_allergies
  has_many :subscriptions, through: :subscription_allergies

  validates :name, presence: :true
end