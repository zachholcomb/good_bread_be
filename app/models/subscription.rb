class Subscription < ApplicationRecord
  after_initialize :set_subscription_type
  
  validates :delivery_day, :subscription_type, presence: true
  belongs_to :user
  has_many :shipments, dependent: :destroy
  enum subscription_type: %w(Monthly Bi-Monthly Weekly)

  def set_subscription_type
    self.subscription_type ||= 0
  end
end