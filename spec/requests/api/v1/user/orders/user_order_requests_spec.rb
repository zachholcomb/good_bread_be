require 'rails_helper'

RSpec.describe 'User order requests' do
  before(:each) do
    @user = User.create!(
      name: "Zach Holcomb",
      email: "zach@example.com",
      address: "594 Humboldt Way",
      password: "1234",
      role: 1
    )
    @item_params = {"name": "Sourdough loaf", "price": 750 }
    @item_params2 = {"name": "Croissant", "price": 450 }
    @item = Item.create(@item_params)
    @item2 = Item.create(@item_params2)

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

  it 'User can create order' do
    order_params = {
      "items": { @item.id => {amount: 1}, @item2.id => {amount: 1} },
      "status": "Pending",
      "delivery_date": "9/5/2020"
    }

    post "/api/v1/users/#{@user.id}/orders", params: order_params, headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(201)

    resp = JSON.parse(response.body, symbolize_names: true)
    expect(resp[:order][:data][:attributes][:delivery_date]).to eq("9/5/2020")

    user = User.last
    expect(user.orders.first.id).to eq(resp[:order][:data][:id].to_i)
  end

  it 'User can see all their orders' do
    order_params = {
      "items": { @item.id => {amount: 1}, @item2.id => {amount: 1} },
      "status": "Pending",
      "delivery_date": "9/5/2020"
    }

    post "/api/v1/users/#{@user.id}/orders", params: order_params, headers: @header
    expect(response).to be_successful
    
    get "/api/v1/users/#{@user.id}/orders", headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    resp = JSON.parse(response.body, symbolize_names: true)
    expect(resp[:data].length).to eq(1)
    expect(resp[:data].first[:attributes][:delivery_date]).to eq('9/5/2020')
    expect(resp[:data].first[:relationships][:items][:data].length).to eq(2)
  end
end