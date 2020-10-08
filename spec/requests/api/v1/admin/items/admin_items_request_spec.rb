require 'rails_helper'

RSpec.describe 'Admin items request' do
  before(:each) do
    @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
    )

    @item_params = {"name": "Sourdough loaf", "price": 750, "item_type": "Bread"}
    @item_params2 = {"name": "Croissant", "price": 450, "item_type": "Bread"}
    @item = Item.create!(@item_params)
    @item2 = Item.create!(@item_params2)

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

  it 'create item request' do
    post "/api/v1/admin/items", params: @item_params, headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(201)
    
    item_response = JSON.parse(response.body, symbolize_names: true)
    expect(item_response[:data][:attributes][:name]).to eq('Sourdough loaf')
  end

  it 'raises error with missing item params' do
    invalid_params = {"name": "Croissant"}
    post '/api/v1/admin/items', params: invalid_params, headers: @header
    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    item_response = JSON.parse(response.body, symbolize_names: true)
    expect(item_response[:data][:attributes][:message]).to eq('Missing required fields')
  end

  it 'can update an item' do
    update_params = {"price": 150}
    put "/api/v1/admin/items/#{@item.id}", params: update_params, headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    item_response = JSON.parse(response.body, symbolize_names: true)
    expect(item_response[:data][:attributes][:price]).to eq(150)
  end

  it 'can delete an item' do
    delete "/api/v1/admin/items/#{@item.id}", headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    item_response = JSON.parse(response.body, symbolize_names: true)
    expect(item_response[:data][:attributes][:name]).to eq(@item.name)
    expect(Item.all.length).to eq(1)
  end
end