require 'rails_helper'

RSpec.describe 'Admin orders request spec' do
  before(:each) do
    @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
    )

    @user1 = User.create!(
      email: 'john@example.com',
      name: 'John Wick',
      address: '900 Victoria St.',
      password: '1234',
      password_confirmation: '1234'
    )

    @item1 = Item.create!(name: 'Sourdough Loaf', price: 750)
    @item2 = Item.create!(name: 'Croissant', price: 450)

    @order1 = @user1.orders.create!(status: 0, delivery_date: '9/18/20')
    OrderItem.create!(order: @order1, item: @item1, quantity: 1)
    
    @order2 = @user1.orders.create!(status: 0, delivery_date: '9/18/20')
    OrderItem.create!(order: @order2, item: @item1, quantity: 1)
    OrderItem.create!(order: @order2, item: @item2, quantity: 1)

    login_params = {
        "email": "admin@example.com",
        "password": "1234"
      }
    post '/api/v1/login', params: login_params
    credentials = JSON.parse(response.body, symbolize_names: true)
    token = credentials[:csrf]
    @header = {
      "X-CSRF-TOKEN": token
    }
  end

  it 'get all order request' do
    get '/api/v1/admin/orders', headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    order_resp = JSON.parse(response.body, symbolize_names: true)
    expect(order_resp[:data].length).to eq(2)
    expect(order_resp[:data].first[:relationships][:items][:data].length).to eq(1)
    expect(order_resp[:data].first[:id].to_i).to eq(@order1.id)
    expect(order_resp[:data].first[:relationships][:user][:data][:id].to_i).to eq(@user1.id)
  end

  it "get a single order request" do
    get "/api/v1/admin/orders/#{@order2.id}", headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    order_resp = JSON.parse(response.body, symbolize_names: true)
    expect(order_resp[:data][:id].to_i).to eq(@order2.id)
    expect(order_resp[:data][:relationships][:user][:data][:id].to_i).to eq(@user1.id)
    expect(order_resp[:data][:relationships][:items][:data].length).to eq(2)
    expect(order_resp[:data][:relationships][:items][:data].first[:id].to_i).to eq(@item1.id)
  end

  it "edit order request" do
    update_params = {
      "delivery_date": "9/17/20"
    }
    put "/api/v1/admin/orders/#{@order1.id}", params: update_params, headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    order_resp = JSON.parse(response.body, symbolize_names: true)
    expect(order_resp[:data][:attributes][:delivery_date]).to eq("9/17/20")
  end
end