class Subscription < ApplicationRecord
  after_initialize :set_subscription_type
  
  validates :delivery_day, :subscription_type, presence: true
  belongs_to :user
  has_many :shipments, dependent: :destroy
  has_many :subscription_allergies
  has_many :allergies, through: :subscription_allergies
  enum subscription_type: %w(Monthly Bi-Monthly Weekly)

  def set_subscription_type
    self.subscription_type ||= 2
  end

  def next_shipment
    shipments.last
  end
end