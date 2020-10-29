class OrderItem < ApplicationRecord
  after_create :set_price
  belongs_to :item
  belongs_to :order
  
  validates :quantity, presence: :true

  def set_price
    self.price = self.item.price
    self.save
  end
end