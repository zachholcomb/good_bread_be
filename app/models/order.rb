class Order < ApplicationRecord
  after_initialize :set_defaults

  validates :status, presence: true
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user
  enum status: %w(Pending Shipped Delivered)

  def set_defaults
    self.status ||= 0
    self.delivery_date ||= Time.now.strftime('%m/%d/%y')
  end

  def calc_total
    self.total = order_items.sum('price * quantity')
    self.save
  end
end
