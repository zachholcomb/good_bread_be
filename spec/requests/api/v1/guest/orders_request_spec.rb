require 'rails_helper'

RSpec.describe 'guest orders' do
  before(:each) do
    @item_params = {"name": "Sourdough loaf", "price": 750 }
    @item_params2 = {"name": "Croissant", "price": 450 }
    @item = Item.create(@item_params)
    @item2 = Item.create(@item_params2)
  end

  it 'guest can order items' do
    order_params = {
      "items": [@item.id, @item2.id],
      "status": "Pending",
      "delivery_date": "9/5/2020",
      "name": "Zach",
      "email": "zach@example.com",
      "address": "594 House Ave.",
      "password": "password",
      "password_confirmation": "password",
      "role": 'guest'
    }
    post "/api/v1/orders", params: order_params
    expect(response).to be_successful
    expect(response.status).to eq(201)

    order_response = JSON.parse(response.body, symbolize_names: true)
    expect(order_response[:order][:data][:attributes][:delivery_date]).to eq("9/5/2020")
    expect(order_response[:order][:data][:relationships][:items][:data].length).to eq(2)
    expect(order_response[:user][:data][:attributes][:email]).to eq('zach@example.com')

    user = User.last
    expect(user.role).to eq('guest')
  end
end
