require 'rails_helper'

RSpec.describe 'Subscriptions requests' do
  describe 'subscriptions crud' do
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
    end

    it "create subscription spec" do
      sub_params = {
        "subscription_type": 0,
        "delivery_day": "Monday"
      }
      post "/api/v1/users/#{@user2.id}/subscription", params: sub_params
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

      post "/api/v1/users/#{@user2.id}/subscription", params: sub_params
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:data][:attributes][:message]).to eq("Missing required fields")
    end

    it "user can update subscription" do
      subscription = @user1.subscription
      update = { "subscription_type": 1 }
      put "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}", params: update
      expect(response).to be_successful
      expect(response.status).to eq(200)

      update_response = JSON.parse(response.body, symbolize_names: true)
      expect(update_response[:data][:attributes][:subscription_type]).to eq(1)
      user = User.find(@user1.id)
      expect(user.subscription.subscription_type).to eq(1) 
    end

    it "user can delete their subscription" do
      subscription = @user1.subscription
      delete "/api/v1/users/#{@user1.id}/subscription/#{subscription.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      delete_response = JSON.parse(response.body, symbolize_names: true)
      expect(delete_response[:data][:attributes][:id]).to eq(subscription.id)
    end

    it 'get all subscriptions' do
      get "/api/v1/subscriptions"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data].length).to eq(1)
      expect(sub_response[:data].first[:attributes][:id]).to eq(@user1.subscription.id)
    end

    it 'can get subscription by id' do
      get "/api/v1/subscriptions/#{@user1.subscription.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data][:attributes][:id]).to eq(@user1.subscription.id)
    end

    it 'has error handling if subscription not found' do
      get "/api/v1/subscriptions/9999999999"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:message]).to eq('Oops, record not found')
    end
  end
end