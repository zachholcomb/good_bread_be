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
        subscription_type: 0,
        delivery_day: "Monday",
        user: @user1
      }
      @subscription = Subscription.create!(subscription_params)

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

    it "create subscription spec" do
      sub_params = {
        "subscription_type": 0,
        "delivery_day": "Monday"
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
      subscription = @user1.subscription
      update = { "subscription_type": 1 }
      put "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}", params: update, headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      update_response = JSON.parse(response.body, symbolize_names: true)
      expect(update_response[:data][:attributes][:subscription_type]).to eq(1)
      user = User.find(@user1.id)
      expect(user.subscription.subscription_type).to eq(1) 
    end

    it "user can delete their subscription" do
      subscription = @user1.subscription
      delete "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      delete_response = JSON.parse(response.body, symbolize_names: true)
      expect(delete_response[:data][:attributes][:id]).to eq(subscription.id)
    end

    it 'can get a users subscription' do
      get "/api/v1/users/#{@user1.id}/subscription/#{@user1.subscription.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data][:attributes][:id]).to eq(@user1.subscription.id)
    end
  end
end