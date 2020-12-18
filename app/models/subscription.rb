class Subscription < ApplicationRecord
  after_initialize :set_subscription_defaults
  
  validates :delivery_day, :subscription_type, presence: true
  belongs_to :user
  has_many :shipments, dependent: :destroy
  has_many :subscription_allergies, dependent: :destroy
  has_many :allergies, through: :subscription_allergies
  enum subscription_type: %w(Monthly Bi-Monthly Weekly)

  def set_subscription_defaults
    self.subscription_type ||= 2
    self.delivery_day ||= 'Thursday'
  end

  def next_shipment
    shipments.last
  end
end