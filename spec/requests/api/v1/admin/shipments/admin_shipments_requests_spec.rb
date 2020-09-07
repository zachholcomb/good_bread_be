require 'rails_helper'

RSpec.describe 'Shipments requests' do
  describe 'shipments crud' do
    before(:each) do
      @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
      )

      @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )

      subscription_params = {
        subscription_type: 0,
        delivery_day: "Monday",
        user: @user
      }

      @subscription = Subscription.create!(subscription_params)
      @shipment = @subscription.shipments.create!(status: 0,
                                                 delivery_date: '9/03/2020'
                                                )
                                                
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

    it 'shipment create request' do
      shipment_params = {
        subscription_id: @subscription.id,
        status: 0,
        delivery_date: '9/05/2020'
      }
      post "/api/v1/admin/shipments", params: shipment_params, headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(201)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:delivery_date]).to eq('9/05/2020')
      user = User.last
      expect(user.subscription.shipments.last.id).to eq(shipment_response[:data][:attributes][:id])
    end

    it 'shipment create request error handling' do
      shipment_params = {
        status: 0,
        delivery_date: '9/05/2020'
      }
      post "/api/v1/admin/shipments", params: shipment_params, headers: @header
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:message]).to eq('Missing required fields')
    end

    it "shipment index request" do
      get '/api/v1/admin/shipments', headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data].length).to eq(1)
      expect(shipment_response[:data].first[:attributes][:id]).to eq(@shipment.id)
    end

    it 'shipment update request' do
      update_params = {
        status: 1
      }
      put "/api/v1/admin/shipments/#{@shipment.id}", params: update_params, headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      shipment = Shipment.last
      expect(shipment_response[:data][:attributes][:status]).to eq(shipment.status)
    end

    it 'shipment delete request' do
      delete "/api/v1/admin/shipments/#{@shipment.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:id]).to eq(@shipment.id)
      user = User.last
      expect(user.subscription.shipments.length).to eq(0)
    end

    it 'shipment show request' do
      get "/api/v1/admin/shipments/#{@shipment.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:id]).to eq(@shipment.id)
    end
  end
end
