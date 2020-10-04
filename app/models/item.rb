class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_initialize :set_defaults  
  has_one_attached :image

  has_many :shipment_items
  has_many :shipments, through: :shipment_items
  has_many :order_items
  has_many :orders, through: :order_items
  validates :name, :price, presence: true
  validates :image, presence: true
  enum status: %w(Active Inactive)
  enum status: %w(Bread Pastries Donuts Bagels)

  def set_defaults
    self.status ||= 0
  end

  def get_image_url
    url_for(self.image)
  end
end
