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
    end

    it 'shipment create request' do
      shipment_params = {
        subscription_id: @subscription.id,
        status: 0,
        delivery_date: '9/05/2020'
      }
      post "/api/v1/shipments", params: shipment_params
      expect(response).to be_successful
      expect(response.status).to eq(201)

      shipment_response = JSON.parse(response.body, symbolize_names: true)
      expect(shipment_response[:data][:attributes][:delivery_date]).to eq('9/05/2020')
      user = User.last
      expect(user.subscription.shipments.last.id).to eq(shipment_response[:data][:attributes][:id])
    end
  end
end