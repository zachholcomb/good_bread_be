require 'rails_helper'

RSpec.describe 'Item requests' do
  describe 'get item_orders' do
    before(:each) do
      @item_params = {"name": "Sourdough loaf", "price": 750 }
      @item_params2 = {"name": "Croissant", "price": 450 }
      @item = Item.create(@item_params)
      @item2 = Item.create(@item_params2)
      @item3 = Item.create(@item_params)
      @item4 = Item.create(@item_params2)

      @user = User.create!(
      name: "Zach Holcomb",
      email: "zach@example.com",
      address: "594 Humboldt Way",
      password: "1234",
      role: 1
      )

      @order1 = @user.orders.create!(status: 0, delivery_date: '9/18/20')
      OrderItem.create!(order: @order1, item: @item, quantity: 1)
      
      @order2 = @user.orders.create!(status: 0, delivery_date: '9/18/20')
      OrderItem.create!(order: @order2, item: @item, quantity: 4)
      OrderItem.create!(order: @order2, item: @item2, quantity: 1)

      login_params = {
          "email": "zach@example.com",
          "password": "1234"
        }
        post '/api/v1/login', params: login_params
        credentials = JSON.parse(response.body, symbolize_names: true)
        token = credentials[:csrf]
        @header = {
          "X-CSRF-TOKEN": token
        }

    end

    it 'can get items by an array' do
      get "/api/v1/users/#{@user.id}/orders/#{@order2.id}/items", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)
      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response[:data].length).to eq(2)
      expect(item_response[:included].first[:id].to_i).to eq(@item.id)
    end
  end
end

