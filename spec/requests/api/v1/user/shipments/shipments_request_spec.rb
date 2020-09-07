require 'rails_helper'

RSpec.describe 'Shipments requests' do
  describe 'shipments crud' do
    before(:each) do
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
        "email": "john@example.com",
        "password": "1234"
      }
      post '/api/v1/login', params: login_params
      credentials = JSON.parse(response.body, symbolize_names: true)
      token = credentials[:csrf]
      @header = {
        "X-CSRF-TOKEN": token
      }
    end

    it 'users shipments show request' do
      get "/api/v1/users/#{@user.id}/shipments/#{@shipment.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:id]).to eq(@shipment.id)
    end

    it 'users shipments index request' do
      get "/api/v1/users/#{@user.id}/shipments", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data].first[:attributes][:id]).to eq(@shipment.id)
    end
  end
end