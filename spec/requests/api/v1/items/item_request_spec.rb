require 'rails_helper'

RSpec.describe 'Item requests' do
  describe 'perform item crud' do
    before(:each) do
      @item_params = {"name": "Sourdough loaf", "price": 750 }
      @item_params2 = {"name": "Croissant", "price": 450 }
      @item = Item.create(@item_params)
      @item2 = Item.create(@item_params2)
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
  end
end