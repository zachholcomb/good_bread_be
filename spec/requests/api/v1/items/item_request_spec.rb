require 'rails_helper'

RSpec.describe 'Item requests' do
  describe 'perform item crud' do
    before(:each) do
      @item_params = {"name": "Sourdough loaf", "price": 750 }
      @item_params2 = {"name": "Croissant", "price": 450 }
      @item = Item.create(@item_params)
      @item2 = Item.create(@item_params2)
    end

    it 'create item request' do
      post "/api/v1/items", params: @item_params
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:name]).to eq('Sourdough loaf')
    end

    it 'raises error with missing item params' do
      invalid_params = {"name": "Croissant"}
      post '/api/v1/items', params: invalid_params
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:message]).to eq('Missing required fields')
    end

    it 'can get all items' do
      get '/api/v1/items' 
      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data].length).to eq(2)
    end

    it 'can get one item' do
      get "/api/v1/items/#{@item.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:name]).to eq(@item.name)
    end

    it 'raises error if item not found' do
      get "/api/v1/items/9029393"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:message]).to eq('Oops, record not found')
    end

    it 'can update an item' do
      update_params = {"price": 150}
      put "/api/v1/items/#{@item.id}", params: update_params
      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:price]).to eq(150)
    end

    it 'can delete an item' do
      delete "/api/v1/items/#{@item.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:name]).to eq(@item.name)
      expect(Item.all.length).to eq(1)
    end
  end
end