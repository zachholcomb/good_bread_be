require 'rails_helper'

RSpec.describe Order do
  describe 'validations' do
    it { should validate_presence_of(:status) }
    # it { should validate_presence_of(:delivery_date) }
  end

  describe 'relationships' do
    it { should have_many(:order_items) }
    it { should have_many(:items).through(:order_items) }
    it { should belong_to(:user) }
  end

  describe 'total' do
    it 'should calculate total' do
      user = User.create!(
      email: 'john@example.com',
      name: 'John Wick',
      address: '900 Victoria St.',
      password: '1234',
      password_confirmation: '1234'
     )
      item_params = {"name": "Sourdough loaf", "price": 750 }
      item_params2 = {"name": "Croissant", "price": 450 }
      item = Item.create(item_params)
      item2 = Item.create(item_params2)

      order = user.orders.create!(status: 0, delivery_date: '9/18/20')
      OrderItem.create!(order: order, item: item, quantity: 1, price: item.price)
      OrderItem.create!(order: order, item: item2, quantity: 1, price: item2.price)

      order.calc_total
      order = Order.last
      expect(order.total).to eq(1200)
    end
  end
end