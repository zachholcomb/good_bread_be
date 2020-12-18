require 'rails_helper'

RSpec.describe 'Subscription requests' do
  describe 'subscription crud' do
    before(:each) do
      @user1 = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )

      @user2 = User.create!(
        email: 'johnathon@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )

      subscription_params = {
        subscription_type: "Monthly",
        delivery_day: "Monday",
        user: @user1
      }
      @subscription = Subscription.create!(subscription_params)
      @shipment = Shipment.create!(
        subscription: @subscription,
        delivery_date: '9/14/2020',
        status: "Delivered"
      )
      @shipment2 = Shipment.create!(
        subscription: @subscription,
        delivery_date: '9/14/2020',
        status: "Shipped"
      )
    end

    it "create subscription spec" do
      login_params = {
        "email": "johnathon@example.com",
        "password": "1234"
      }
      post '/api/v1/login', params: login_params
      credentials = JSON.parse(response.body, symbolize_names: true)
      token = credentials[:csrf]
      @header = {
        "X-CSRF-TOKEN": token
      }
      sub_params = {
        "subscription_type": "Monthly",
        "delivery_day": "Monday",
        "amount": '1',
        "allergies": "Walnuts, Blueberries",
        "flavors?": true
      }
      post "/api/v1/users/#{@user2.id}/subscription", params: sub_params, headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data][:attributes][:user_id]).to eq(@user2.id)

      subscription = Subscription.last
      expect(@user2.subscription).to eq(subscription)
    end

    it "create subscription error handling missing params" do
      login_params = {
        "email": "johnathon@example.com",
        "password": "1234"
      }
      post '/api/v1/login', params: login_params
      credentials = JSON.parse(response.body, symbolize_names: true)
      token = credentials[:csrf]
      @header = {
        "X-CSRF-TOKEN": token
      }
      sub_params = {
        "delivery_day": "Monday"
      }

      post "/api/v1/users/#{@user2.id}/subscription", params: sub_params, headers: @header
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:data][:attributes][:message]).to eq("Missing required fields")
    end

    it "user can update subscription" do
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
      subscription = @user1.subscription
      update = { "subscription_type": "Bi-Monthly" }
      put "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}", params: update, headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      update_response = JSON.parse(response.body, symbolize_names: true)
      expect(update_response[:data][:attributes][:subscription_type]).to eq("Bi-Monthly")
      user = User.find(@user1.id)
      expect(user.subscription.subscription_type).to eq("Bi-Monthly") 
    end

    it "user can delete their subscription" do
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
      subscription = @user1.subscription
      delete "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      delete_response = JSON.parse(response.body, symbolize_names: true)
      expect(delete_response[:data][:attributes][:id]).to eq(subscription.id)
    end

    it 'can get a users subscription' do
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
      get "/api/v1/users/#{@user1.id}/subscription", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:subscription][:data][:attributes][:id]).to eq(@user1.subscription.id)
    end

    it 'returns next shipment along with subscription' do
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
      get "/api/v1/users/#{@user1.id}/subscription", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:shipment][:data][:attributes][:id]).to eq(@shipment2.id)
    end
  end
end